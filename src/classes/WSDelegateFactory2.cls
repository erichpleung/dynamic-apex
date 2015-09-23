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
 public class WSDelegateFactory2 {

	// singleton pattern, stop this class from being constructed
	private WSDelegateFactory2(){}
	private static WSDelegateFactory2 instance = new WSDelegateFactory2();
	public static WSDelegateFactory2 getInstance(){
		return instance;
	}

	private static Map<String,Service_Setting__c> delegates = Service_Setting__c.getAll();

	// factory pattern
	public AbstractDelegateImple getImpl(String version, String apiName){
		Service_Setting__c delegate=null;
		for(Service_Setting__c d:delegates.values()){
			if(delegate!=null){break;}
			else if(d.version__c==version && d.api_name__c==apiName){
				delegate=d;
			}
		}
		if(delegate==null){throw new WSException(404,'unknown version and interface');}
		System.Type implType=System.Type.forName(delegate.delegate_class__c);
		AbstractDelegateImple c = (AbstractDelegateImple)implType.newInstance();
		c.config = delegate;
		return c;
	}

	public WSProxy2 create(String version, String apiName){
		return new WSProxy2(getImpl(version,apiName));
	}	
}