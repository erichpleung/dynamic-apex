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
 *  @Author: Ben Naylor
 *
 */
 @RestResource(urlMapping='/DFDemo2/account/*')
global with sharing class SecondDemoWS_Account {
	// this is the hierarchy settings

	@HttpGet
	global static void getAccount() {
		RestResponse res = RestContext.response;
		RestRequest req = RestContext.request;
        res.addHeader('Content-Type','application/json');
		try{
			if (!Access_Settings__c.getInstance().getAccount__c) {
				throw new WSException(400, 'You do not have access to get Accounts');
			}
	
			String objId=WSUtils.getURIParameters(req.requestUri,3);
	
			try {
				Id.valueOf(objId);
			} catch (Exception e) {
				throw new WSException(400,'Invalid Id Passed');
			}
	
			Account a;
			try {
				a = [ select Id, Name from Account where Id = :objId ];
				res.responseBody = Blob.valueOf(JSON.serialize(new WSAccount(a)));
			} catch (Exception e) {
				throw new WSException(400, 'Could not find account with id: ' + objId);
			}
		}catch(WSException ex){
			WSUtils.handleException(ex,res);
		}
	}

	global class WSAccount {
		global Account account;
		global String RequestDate;

		global WSAccount(Account a) {
			this.account = a;
			this.RequestDate = System.now().format(Access_Settings__c.getInstance().DT_Format__c);
		}

	}
}