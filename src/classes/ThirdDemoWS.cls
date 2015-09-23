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
 @RestResource(urlMapping='/DF15Demo3/*')
global with sharing class ThirdDemoWS {


	@HttpPost
	global static String createData(){
		RestRequest req = RestContext.request;
		RestResponse res = Restcontext.response;
 		res.addHeader('Content-Type','application/json');
		res.statuscode=201;//created

		try{
			String vers=WSUtils.getURIParameters(req.requestUri,2);
			if(String.isBlank(vers)){
				throw new WSException(404, '');
			}

			// using factory to get an instance of proxy
			WSInterface2 proxy = WSDelegateFactory2.getInstance().create(vers,'saveCustomer');
			// using proxy to create customer
			return proxy.createCustomer(req.requestBody.toString());
		}catch (WSException ex){
			WSUtils.handleException(ex,res,'');
		}
		return null;
	}


	@HttpGet
	global static void fetchData(){
		RestRequest req = RestContext.request;
		RestResponse res = Restcontext.response;
		res.addHeader('Content-Type','application/json');

		try{		
			String vers=WSUtils.getURIParameters(req.requestUri,2);
			String objId=WSUtils.getURIParameters(req.requestUri,3);
			if(String.isBlank(vers)||String.isBlank(objId)){
				throw new WSException(404, '');
			}

			// using factory to get an instance of proxy
			WSInterface2 proxy = WSDelegateFactory2.getInstance().create(vers,'getCustomer');
			// using proxy to create customer
			res.responseBody = Blob.valueOf(JSON.serialize(proxy.getCustomer(objId)));
		}catch (WSException ex){
			WSUtils.handleException(ex,res,'');
		}
	}
	
	

}