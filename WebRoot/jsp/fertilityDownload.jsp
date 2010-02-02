<%@ page contentType="text/csv" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.nescent.plhdb.util.SearchFertilityForm" %>
<%       
response.setContentType("application/ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=download.csv");
SearchFertilityForm form=(SearchFertilityForm)request.getAttribute("searchForm");
List records=(List)request.getAttribute("fertilities");
List showFields=(List)request.getAttribute("showFields");
for(int i=0;i<showFields.size();i++){
    String field=(String)showFields.get(i);
    out.write("\""+field+"\"");
    if(i<showFields.size()-1)
    	out.write(",");
}

out.write("\n");
String str="";
SimpleDateFormat sdf=new SimpleDateFormat("dd-MMM-yyyy");
out.write("Total: "+ records.size() + "\n");
out.write("search criteria ");
    out.write( (form.getOp_studyid().indexOf("NULL")>-1 || form.getValue_studyid()!=null)?", Study Id "+form.getOp_studyid()+(form.getValue_studyid()!=null?" '"+form.getValue_studyid()+"'":""):"" );
    out.write( (form.getOp_animid().indexOf("NULL")>-1 || form.getValue_animid()!=null)?", Animal Id "+form.getOp_animid()+(form.getValue_animid()!=null?" '"+form.getValue_animid()+"'":""):"" );
    out.write( (form.getOp_startdate().indexOf("NULL")>-1 || form.getValue_startdate()!=null)?", Entry Date "+form.getOp_startdate()+(form.getValue_startdate()!=null?" '"+form.getValue_startdate()+"'":""):"" );
    out.write( (form.getOp_starttype().indexOf("NULL")>-1 || form.getValue_starttype()!=null)?", Entry Type "+form.getOp_starttype()+(form.getValue_starttype()!=null?" '"+form.getValue_starttype()+"'":""):"" );
    out.write( (form.getOp_stopdate().indexOf("NULL")>-1 || form.getValue_stopdate()!=null)?", Depart Date "+form.getOp_stopdate()+(form.getValue_stopdate()!=null?" '"+form.getValue_stopdate()+"'":""):"" );
    out.write( (form.getOp_stoptype().indexOf("NULL")>-1 || form.getValue_stoptype()!=null)?", Depart Type "+form.getOp_stoptype()+(form.getValue_stoptype()!=null?" '"+form.getValue_stoptype()+"'":""):"" );
out.println("\n");
for(int i=0;i<records.size();i++){
    str="";
    Object [] record=(Object []) records.get(i);
    for(int j=0;j<record.length;j++){
	if(record[j] instanceof Date){
	    Date d=(Date)record[j];
	    str+="\""+sdf.format(d)+"\"";
	}else{
	    str+="\""+record[j]+"\"";
	}
	if(j<record.length-1)
	    str+=",";
	
    }
    out.write(str+"\n");
}
%>