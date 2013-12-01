global with sharing class sf1ReportController {
/*
Need to add your VF domain to remote site settings as an authorized endpoint!
EX: https://c.cs4.visual.force.com
*/


	public sf1ReportController() {
	}

	@RemoteAction
	global static String searchReports(String searchTerm) {
		List<Report> rList = new List<Report>(); 
		List<List<sObject>> searchList = [FIND :searchTerm IN ALL FIELDS RETURNING Report(Id, Name)];
		if (searchList != null) {
			if (!searchList.isEmpty()) {
		        try {
					for (sObject s: searchList[0]) {
						rList.add((Report)s);					
					}
		        } catch(System.Exception e) {
		            System.debug('Search error: '+ e);
		        } 
			}			
		}
		
	
		String sReturn = '';
		for (Report r : rList ) {
			sReturn += '<li><a class=\'reportLink\' href=\'#reportPage?reportId='+r.Id+'\'>' + r.Name + '</a></li>';
		}
		
		if (Test.isRunningTest()) {
			sReturn = sf1ReportController_TEST.getReportLinks();	
		}
				
		sReturn = JSON.serialize(sReturn);		
		sReturn = sReturn.removeStart('"');
		sReturn = sReturn.removeEnd('"');
	
		return sReturn;
	}

	
	@RemoteAction
	global static Map<String, String> getAndFormatReport(String reportId, Boolean isToggle) {
		String sJSON;
		sJSON = getReportById(reportId, true);
	
		//parse out the JSON
		String reportName;
		String reportFormat;
		String message = '';
		String errorCode = '';
		String tableHTML;
		 
		JSONParser parser = JSON.createParser(sJSON);
		while (parser.nextToken() != null) {
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'reportName')) {
				parser.nextToken();
				reportName = parser.getText(); 	
			}
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'reportFormat')) {
				parser.nextToken();
				reportFormat = parser.getText(); 	
			}
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'message')) {
				parser.nextToken();
				message = parser.getText(); 	
			}
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'errorCode')) {
				parser.nextToken();
				errorCode = parser.getText(); 	
			}
		} 		

		List<String> headerRow = new List<String>();
		List<List<String>> rowList = new List<List<String>>();		
		if (reportFormat == 'TABULAR') {
			parser = JSON.createParser(sJSON);
			List<String> fieldList = new List<String>();
			while (parser.nextToken() != null) {
				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'dataCells')) {
					fieldList = new List<String>();
					while (parser.nextToken() != null)  {
						if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'label')) {
							parser.nextToken();
							fieldList.add(parser.getText()); 		
						}
						if (parser.getCurrentToken() == JSONToken.END_ARRAY) {
							rowList.add(fieldList);
							break;
						}
					} 
				} 
				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'detailColumnInfo')) {
					System.JSONToken lastToken;
					while (parser.nextToken() != null) {
						if ((lastToken == JSONToken.END_OBJECT) && (parser.getCurrentToken() == JSONToken.END_OBJECT)) { //2 end objects in a row.  done with header.
							break;	
						} 
						if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'label')) {
							parser.nextToken();
							headerRow.add(parser.getText()); 		
						}
						lastToken = parser.getCurrentToken();						
					}	
				}
			}	
		}
		
		
		tableHTML = '';
		if (isToggle) {
			tableHTML += '<table data-role="table" id="table-column-toggle" data-mode="columntoggle" class="ui-responsive table-stroke small-text">';
		} else {
			tableHTML += '<table data-role="table" id="table-column-toggle" class="ui-responsive table-stroke">';
		} 
	
		tableHTML += '<thead>';
		tableHTML += '<tr>';
		Integer priorityCount = 1;
		for (String h: headerRow) {
			String sPriority = ' data-priority="'+priorityCount+'"';
			tableHTML += '<th '+sPriority+'>'+h+'</th>';
			priorityCount++;
		}
		tableHTML += '</tr>';
		tableHTML += '</thead>';		
		tableHTML += '<tbody>';
		for (List<String> fieldList: rowList) {
			tableHTML += '<tr>';
			Integer intCount = 0;
			for (String f: fieldList) {
				if (intCount == 0) {
					tableHTML += '<th>'+f+'</th>';	
				} else {
					tableHTML += '<td>'+f+'</td>';
				}
				intCount++;	
			}
			tableHTML += '</tr>';		
		}
		tableHTML += '</tbody>';		
		tableHTML += '</table>';

		if (reportFormat != 'TABULAR') {
			message = 'Report is: ' + reportFormat + ' format.  Currently only Tabular reports are supported in v1.0';	
		}

		Map<String, String> returnMap = new Map<String, String>();
		returnMap.put('reportName', reportName);
		returnMap.put('reportFormat', reportFormat);
		returnMap.put('message', message);
		returnMap.put('errorCode', errorCode);
		returnMap.put('tableHTML', tableHTML);
		
		return returnMap;
	}

	
	public static String getReportById(String reportId, Boolean includeDetails) {
		String sJSON;
		if (reportId != null) {
			String sReq = reportId;
			if (includeDetails) {
				sReq +=  '?includeDetails=true';
			}
			sJSON = restRequest(sReq);
		}
		return sJSON;
	}



	public static String restRequest(String sInput) {
		String sJSON;
		
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		Http http = new Http();
 
		String sUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v29.0/analytics/reports/'+sInput;
		
		req.setEndpoint(sUrl);
		req.setMethod('GET');
		req.setHeader('Authorization', 'Bearer '+UserInfo.getSessionId());		 
		req.setHeader('Content-Type', 'application/json');
		req.setCompressed(true);
 
        try {
			if (Test.isRunningTest()) {
				sJSON = sf1ReportController_TEST.getReportJson();
			} else {
	            res = http.send(req);
	            sJSON = res.getBody();
			}
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        } 
        
		return sJSON;
    }		






}