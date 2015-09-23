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
 public class WSDelegateFactory {
	// singleton pattern, stop this class from being constructed
	private WSDelegateFactory(){}
	private static WSDelegateFactory instance = new WSDelegateFactory();
	public static WSDelegateFactory getInstance(){
		return instance;
	}

	// factory pattern
	public WSInterface createDelegate(String version){
		if(version=='v1'){
			// create a proxy with implementation of Version 1
			return new WSProxy(new FirstDemoV1Impl());
		}else if(version=='v2'){
			// create a proxy with implementation of version 2
			return new WSProxy(new FirstDemoV2Impl());
		}
		throw new WSException(404,'unknown version');
	}

}