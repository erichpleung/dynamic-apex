/** 
 *  Copyright 2015 Fronde Systems Group Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  @Author: Eric Leung
 *
 */
 @isTest (seeAllData=false)
private class Demo3Test {
	public class MockImpl extends AbstractDelegateImple{
		public SObject getCustomer(String objId){
			return fetch(objId);
		}
		public String createCustomer(String jsonObj){
			SObject obj = create(getObjectValueMap(jsonObj,0));
			return obj.id;
	    }
	}

	@TestSetup
	static void setup(){
		Service_Setting__c[] configData=new Service_Setting__c[]{
			new Service_Setting__c(name='TestV1GC',version__c='v1',api_name__c='getCustomer',delegate_class__c='ThirdDemoV1Imple',object_type__c='Lead',fields__c='firstName=FirstName,lastName=LastName,phone=Phone'),
			new Service_Setting__c(name='TestV1SC',version__c='v1',api_name__c='saveCustomer',delegate_class__c='ThirdDemoV1Imple',object_type__c='Lead',fields__c='firstName=FirstName,lastName=LastName,phone=Phone'),
			new Service_Setting__c(name='TestV2GC',version__c='v2',api_name__c='getCustomer',delegate_class__c='ThirdDemoV2Imple',object_type__c='Contact',fields__c='firstName=FirstName,lastName=LastName,phone=MobilePhone'),
			new Service_Setting__c(name='TestV2SC',version__c='v2',api_name__c='saveCustomer',delegate_class__c='ThirdDemoV2Imple',object_type__c='Contact',fields__c='firstName=FirstName,lastName=LastName,phone=MobilePhone'),
			new Service_Setting__c(name='TestV3GC',version__c='v3',api_name__c='getCustomer',delegate_class__c='Demo3Test.MockImpl',object_type__c='Account',fields__c='name=Name,phone=Phone,web=Website'),
			new Service_Setting__c(name='TestV3SC',version__c='v3',api_name__c='saveCustomer',delegate_class__c='Demo3Test.MockImpl',object_type__c='Account',fields__c='name=Name,phone=Phone,web=Website')
		};
		insert configData;
	}
	
	@isTest
	static void testVersion1(){
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo3/v1/';
		RestContext.request.httpMethod = 'POST';   
		RestContext.request.requestBody=Blob.valueof('{"lead":{"firstName":"Bruce","phone":"541-098-9988","lastName":"Wayne"}}');
		String objId = ThirdDemoWS.createData();
   		system.assertEquals(201, RestContext.response.statusCode);
		system.assert(!String.isBlank(objId));

		//reset
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo3/v1/'+objId;
		RestContext.request.httpMethod = 'GET';   
		ThirdDemoWS.fetchData();
		String jsonResp = RestContext.response.responseBody.toString();
		try{
			Lead sobj = (Lead) system.JSON.deserialize(jsonResp, Lead.class);
			system.assertEquals('Bruce',sobj.FirstName);
			system.assertEquals('Wayne',sobj.LastName);
			system.assertEquals('541-098-9988',sobj.Phone);
		} catch (Exception ex){
			system.assertNotEquals(null,ex,ex.getStacktraceString());
		}

	}

	@isTest
	static void testVersion2(){
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo3/v2/';
		RestContext.request.httpMethod = 'POST';   
		RestContext.request.requestBody=Blob.valueof('{"Contact":{"firstName":"Peter","lastName":"Parker","phone":"555-555-5555"}}');
		String objId = ThirdDemoWS.createData();
   		system.assertEquals(201, RestContext.response.statusCode);
		system.assert(!String.isBlank(objId));

		//reset
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo3/v2/'+objId;
		RestContext.request.httpMethod = 'GET';   
		ThirdDemoWS.fetchData();
		String jsonResp = RestContext.response.responseBody.toString();
		try{
			Contact sobj = (Contact) system.JSON.deserialize(jsonResp, Contact.class);
			system.assertEquals('Peter',sobj.FirstName);
			system.assertEquals('Parker',sobj.LastName);
			system.assertEquals('555-555-5555',sobj.MobilePhone);
		} catch (Exception ex){
			system.assertNotEquals(null,ex,ex.getStacktraceString());
		}

	}

	@isTest
	static void testVersion3(){
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo3/v3/';
		RestContext.request.httpMethod = 'POST';   
		RestContext.request.requestBody=Blob.valueof('{"name":"Happy Co.","phone":"541-098-9988","web":"www.happy.com"}');
		String objId = ThirdDemoWS.createData();
   		system.assertEquals(201, RestContext.response.statusCode);
		system.assert(!String.isBlank(objId));

		//reset
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo3/v3/'+objId;
		RestContext.request.httpMethod = 'GET';   
		ThirdDemoWS.fetchData();
		String jsonResp = RestContext.response.responseBody.toString();
		try{
			Account sobj = (Account) system.JSON.deserialize(jsonResp, Account.class);
			system.assertEquals('Happy Co.',sobj.Name);
			system.assertEquals('www.happy.com',sobj.Website);
			system.assertEquals('541-098-9988',sobj.Phone);
		} catch (Exception ex){
			system.assertNotEquals(null,ex,ex.getStacktraceString());
		}
	}

	@isTest
	static void testException_1(){
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo3/v1/';
		RestContext.request.httpMethod = 'GET';   
		ThirdDemoWS.fetchData();
   		system.assertEquals(404, RestContext.response.statusCode);
	}

	@isTest
	static void testException_2(){
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo3/v4/';
		RestContext.request.httpMethod = 'POST';   
		RestContext.request.requestBody=Blob.valueof('{}');
		String objId = ThirdDemoWS.createData();
   		system.assertEquals(404, RestContext.response.statusCode);
	}

}