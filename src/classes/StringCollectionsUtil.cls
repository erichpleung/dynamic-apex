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
public class StringCollectionsUtil{
	public static string[]toList(String input,String delimiter){
		String[]ret=new String[]{};
		if(String.isBlank(input)){return ret;}
		for(String a:input.split(delimiter)){
			if(!String.isBlank(a)){ret.add(a);}
		}
		return ret;
	}
	public static Map<String,String>toMap(String input,String recordDelimiter,String keyDelimiter){
		Map<String,String>ret=new Map<String,String>();
		if(String.isBlank(input)){return ret;}
		for(String s:toList(input,recordDelimiter)){
			String[]kv=s.split(keyDelimiter);
			if(kv.size()==2&&!String.isBlank(kv[0])&&!String.isBlank(kv[1])){
				ret.put(kv[0].trim(),kv[1]);
			}
		}
		return ret;
	}
	/** in the format of a=b,c=d,d=f */
	public static Map<String,String>toMap(String commaDelimitedMapList){
		return toMap(commaDelimitedMapList,',','=');
	}
}