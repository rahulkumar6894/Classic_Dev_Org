/*********************************************************************************
** Module Name : Cls_SchemaObjectClass
** Description : This class is used to return the api name of Navatar Setup object, Preqin Access Token and Preqin Refresh token fields. And It also check the field accessible and updatable permission.
** Revision History:-
** Version   Date        Author        WO#   Description of Action
** 1.2      02/07/2018  Kumar Jonson        This class is used to return the api name of Navatar Setup object, Preqin Access Token and Preqin Refresh token fields. And It also check the field accessible and updatable permission.

*********************************************************************************/
//Common method to get the namespace and schemaObject
public class Cls_SchemaObjectClass{
    public static SchemaWrapper getSchemaNameSapce(){
        try{
            SchemaWrapper sw = new SchemaWrapper();
            String accessTokenfield='';
            String refreshTokenfield='';
            String TOKEN_SOBJECT_NAME = 'Navatar_Setup__c';
            integer indexOfToken = -1;
            String namespsacePrefix = null;
            for ( Schema.SObjectType typ : Schema.getGlobalDescribe().values()){
                String sobjName = String.valueOf(typ);
                if (sobjName != null){
                    indexOfToken = sobjName.indexOf(TOKEN_SOBJECT_NAME);
                }
                if (indexOfToken != -1){
                    namespsacePrefix = sobjName.substring(0, indexOfToken);
                    break;
                }
            }// for close
            system.debug('>>namespsacePrefix  '+namespsacePrefix);
            String objName = namespsacePrefix+TOKEN_SOBJECT_NAME;
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType navSchema = schemaMap.get(objName);
            Map<String, Schema.SObjectField> fieldMap = navSchema.getDescribe().fields.getMap();
                for (String fieldName: fieldMap.keySet()) { 
                    //It provides to get the object fields label.
                    String fieldApi = fieldMap.get(fieldName).getDescribe().getName();
                    system.debug('==FieldApi'+fieldApi);
                    If(fieldApi.contains('Preqin_Access_Token__c')){
                        accessTokenfield = fieldApi;
                    }
                    If(fieldApi.contains('Preqin_Refresh_Token__c')){
                        refreshTokenfield = fieldApi;
                    }
                }
            sw.wraprefreshToken = refreshTokenfield;
            sw.wrapaccessToken = accessTokenfield;
            sw.navSetupobj = navSchema;
            system.debug('sw>>>'+sw);
            return sw;
        }
        catch(exception e){
            return null;
        }
        
    }
    public static Boolean isAccessible(String sObjectType, String fieldName)
    {
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
        return fieldDescribe.isAccessible();
    }
    public static Boolean isUpdateable(String sObjectType, String fieldName)
    {
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
        return fieldDescribe.isUpdateable();
    }
    public class SchemaWrapper{
        public Schema.SObjectType navSetupobj;
        public String wraprefreshToken;
        public String wrapaccessToken;
    }
}