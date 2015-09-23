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
@isTest(seeAllData=false)
private class Demo1Test {
	
	@isTest
	static void testVersion1(){
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo1/v1/';
		RestContext.request.httpMethod = 'POST';   
		Lead obj = new Lead(FirstName='Bruce',LastName='Wayne',Phone='541-098-9988');
		String objId = FirstDemoWSV1.createData(obj);
   		system.assertEquals(201, RestContext.response.statusCode);
		system.assert(!String.isBlank(objId));

		//reset
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo1/v1/'+objId;
		RestContext.request.httpMethod = 'GET';   
		FirstDemoWSV1.fetchData();
		system.assertNotEquals(null, RestContext.response.responseBody);
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
		RestContext.request.requestURI = '/DF15Demo1/v2/';
		RestContext.request.httpMethod = 'POST';   
		Contact obj = new Contact(FirstName='Peter',LastName='Parker',Phone='555-555-5555');
		String objId = FirstDemoWSV2.createData(obj);
   		system.assertEquals(201, RestContext.response.statusCode);
		system.assert(!String.isBlank(objId));

		//reset
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo1/v2/'+objId;
		RestContext.request.httpMethod = 'GET';
		FirstDemoWSV2.fetchData();
		system.assertNotEquals(null, RestContext.response.responseBody);
		String jsonResp = RestContext.response.responseBody.toString();
		try{
			Contact sobj = (Contact) system.JSON.deserialize(jsonResp, Contact.class);
			system.assertEquals('Peter',sobj.FirstName);
			system.assertEquals('Parker',sobj.LastName);
			system.assertEquals('555-555-5555',sobj.Phone);
		} catch (Exception ex){
			system.assertNotEquals(null,ex,ex.getStacktraceString());
		}
	}

	@isTest
	static void testException_1(){
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo1/v1/';
		RestContext.request.httpMethod = 'GET';   
		FirstDemoWSV2.fetchData();
   		system.assertEquals(404, RestContext.response.statusCode);
	}

	@isTest
	static void testException_2(){
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
		RestContext.request.requestURI = '/DF15Demo1/v2/';
		RestContext.request.httpMethod = 'GET';   
		FirstDemoWSV1.fetchData();
   		system.assertEquals(404, RestContext.response.statusCode);
	}

}