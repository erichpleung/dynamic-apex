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
 @RestResource(urlMapping='/DFDemo2/permissions')
global with sharing class SecondDemoWS_Permissions {
    
    @HttpGet
    global static Permissions getPermissions() {
        return new Permissions();
    }
    
    global class Permissions {
        public Boolean getAccount;
        public Boolean getLead;
        public String DTFormat;

        global Permissions() {
            Access_Settings__c setting = Access_Settings__c.getInstance();
            this.getAccount = setting.getAccount__c;
            this.getLead = setting.getLead__c;
            this.DTFormat = setting.DT_Format__c; 
        }
    }    

}