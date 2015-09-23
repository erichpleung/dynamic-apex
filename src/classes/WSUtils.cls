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
 public class WSUtils {

	public static String getURIParameters(String uri,integer position){
		if(uri==null||position==0){return null;}
		String[]pts=new String[]{};
		for(String s:uri.split('/')){
			if(!String.isBlank(s)){pts.add(s);}
		}
		if(position>pts.size()){return null;}
		return pts[position-1];
	}
		
	public static void handleException(WSException ex, RestResponse resp){
		handleException(ex,resp,null);
	}

	public static void handleException(WSException ex, RestResponse resp, Object body){
		resp.statusCode=ex.httpStatus;
		if(body==null){
			//resp.responseBody=system.Blob.valueof('{"error":'+system.JSON.serialize(ex)+'}');
			resp.responseBody=system.Blob.valueof('{"error":"'+ex.getMessage()+'"}');
		}else{
			resp.responseBody=system.Blob.valueof(system.JSON.serialize(body));
		}
		system.debug(LoggingLevel.ERROR, ex.getMessage() + '\n'+ex.getStackTraceString());
	}

}