@isTest
public class sf1ReportController_TEST {

	@isTest
	static void doTest() {		
		sf1ReportController.searchReports('danpeter');
		sf1ReportController.getAndFormatReport('00OP00000001111111', true);
		sf1ReportController.getAndFormatReport('00OP00000001111111', false);
	}


	public static String getReportLinks() {
		return
		'<li><a class=\'reportLink\' href=\'#reportPage?reportId=00OP00000001111111\'>Danpeter Report</a></li>'+		
		'<li><a class=\'reportLink\' href=\'#reportPage?reportId=00OP00000001111112\'>Danpeter Report2</a></li>';
	}

	public static String getReportJson() {
		return
		'{'+
		'   "hasDetailRows":true,'+
		'   "attributes":{'+
		'      "instancesUrl":"/services/data/v29.0/analytics/reports/00OP00000001111111/instances",'+
		'      "describeUrl":"/services/data/v29.0/analytics/reports/00OP00000001111111/describe",'+
		'      "type":"Report",'+
		'      "reportName":"Danpeter Report",'+
		'      "reportId":"00OP00000001111111"'+
		'   },'+
		'   "reportMetadata":{'+
		'      "name":"Danpeter Report",'+
		'      "id":"00OP00000001111111",'+
		'      "developerName":"Danpeter_Report",'+
		'      "reportFormat":"TABULAR",'+
		'      "currency":"USD",'+
		'      "reportBooleanFilter":null,'+
		'      "reportFilters":['+
		'         {'+
		'            "value":"dan@danpeter.com",'+
		'            "operator":"equals",'+
		'            "column":"Contact.Email"'+
		'         }'+
		'      ],'+
		'      "detailColumns":['+
		'         "Contact.Name",'+
		'         "Contact.Email"'+
		'      ],'+
		'      "reportType":{'+
		'         "type":"Contacts_Only__c",'+
		'         "label":"Contacts Only"'+
		'      },'+
		'      "aggregates":['+
		'         "RowCount"'+
		'      ],'+
		'      "groupingsDown":['+
		'      ],'+
		'      "groupingsAcross":['+
		'      ]'+
		'   },'+
		'   "reportExtendedMetadata":{'+
		'      "detailColumnInfo":{'+
		'         "Contact.Name":{'+
		'            "dataType":"string",'+
		'            "label":"Full Name"'+
		'         },'+
		'         "Contact.Email":{'+
		'            "dataType":"email",'+
		'            "label":"Email"'+
		'         }'+
		'      },'+
		'      "aggregateColumnInfo":{'+
		'         "RowCount":{'+
		'            "dataType":"int",'+
		'            "label":"Record Count",'+
		'            "acrossGroupingContext":null,'+
		'            "downGroupingContext":null'+
		'         }'+
		'      },'+
		'      "groupingColumnInfo":{'+
		'      }'+
		'   },'+
		'   "groupingsDown":{'+
		'      "groupings":['+
		'      ]'+
		'   },'+
		'   "groupingsAcross":{'+
		'      "groupings":['+
		'      ]'+
		'   },'+
		'   "factMap":{'+
		'      "T!T":{'+
		'         "rows":['+
		'            {'+
		'               "dataCells":['+
		'                  {'+
		'                     "value":"003P0000001111111",'+
		'                     "label":"Daniel Peter"'+
		'                  },'+
		'                  {'+
		'                     "value":"dan@danpeter.com",'+
		'                     "label":"dan@danpeter.com"'+
		'                  }'+
		'               ]'+
		'            }'+
		'         ],'+
		'         "aggregates":['+
		'            {'+
		'               "value":1,'+
		'               "label":"1"'+
		'            }'+
		'         ]'+
		'      }'+
		'   },'+
		'   "allData":true'+
		'}';
	}













}