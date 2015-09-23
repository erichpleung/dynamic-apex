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
 @RestResource(urlMapping='/DFDemo2/list/*')
global with sharing class SecondDemoWS_Lists {
    // list type demo
    
    @HttpGet
    global static void getList() {
        RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        try {
	        String objId=WSUtils.getURIParameters(req.requestUri,3);
	        
	        try {
	            ID.valueOf(objId);
	        } catch (Exception e) {
	            throw new WSException(400, 'ID is not valid');
	        }
	        
	        String idPrefix = objId.substring(0,3);
	        
	        Map<String, Schema.sObjectType> globalDescribe = Schema.getGlobalDescribe(); 
	        
	        String objType;
	        for (String k : globalDescribe.keySet()){
	            if (idPrefix == globalDescribe.get(k).getDescribe().getKeyPrefix()) {
	                objType = k;
	                break;
	            }
	        }
	
	        system.debug(objType);
	
	        Map<String,Object_Type__c> objects = Object_Type__c.getAll();
	
	        if (!objects.containsKey(objType)) {
	            throw new WSException(400, 'Could not find an object with the name: ' + objType);
	        }
	
	        Object_Type__c obj = objects.get(objType);
	
	        String query = 'SELECT ' + obj.Fields__c + ' FROM ' + objType + ' WHERE id = \'' + objId + '\'';
	        
	        res.responseBody = Blob.valueOf(JSON.serialize(Database.query(query)));
        } catch (WSException ex){
        	WSUtils.handleException(ex,res);
        }
    }
}