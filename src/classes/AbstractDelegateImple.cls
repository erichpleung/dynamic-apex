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
public abstract class AbstractDelegateImple implements WSInterface2 {

	public Service_Setting__c config{set;get;}

	protected SObject create(Map<String,String>objValues){
		return create(objValues,true);
	}
	protected SObject create(Map<String,String>objValues,boolean insertRecord){
		// the key should match the key in the input values
		Map<String,String>fieldMapping = new Map<String,String>(), temp=StringCollectionsUtil.toMap(config.fields__c);
		for(String k: temp.keySet()){
			fieldMapping.put(k.toLowercase(),temp.get(k));
		}
		
		Map<String,String>saveValues = new Map<String,String>();
		// make the key case insensitive
		for(String k: objValues.keySet()){
			String t=k.toLowercase();
			if(fieldMapping.containsKey(t)){
				saveValues.put(fieldMapping.get(t),objValues.get(k));
			}
		}

		Schema.sObjectType objType = Schema.getGlobalDescribe().get(config.object_type__c);
		SObject obj = objType.newSObject();

        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        for (Schema.SObjectField field : fieldMap.values()) {
        	if(saveValues.containsKey(field.getDescribe().getName())){
            	obj.put(field, saveValues.get(field.getDescribe().getName()));
        	}
        }
        if(insertRecord){
        	insert obj;
        }
		return obj;
	}

	protected SObject fetch(String objId){
		Map<String,String>fieldMapping = StringCollectionsUtil.toMap(config.fields__c);
		String fieldLists='';
		for(String sObjectField: fieldMapping.values()){
			fieldLists+=String.isBlank(fieldLists)?'':',';
			fieldLists+=sObjectField;
		}		
        String query = 'SELECT ' + fieldLists + ' FROM ' + config.object_type__c + ' WHERE id = \'' + objId + '\'';
        return Database.query(query);
	}

	protected Map<String,String> getObjectValueMap(String jsonObj, integer skipElement){
		JSONParser parser = JSON.createParser(jsonObj);
		for(integer i=0;i<skipElement;i++){parser.nextToken();}
		Type t = Type.forName('Map<String,String>');
		return (Map<String,String>)parser.readValueAs(t);
	}
}