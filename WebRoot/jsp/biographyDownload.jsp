<%@ page contentType="text/csv" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.nescent.plhdb.util.SearchBiographyForm" %>
<%       
response.setContentType("application/ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=download.csv");
SearchBiographyForm form=(SearchBiographyForm)request.getAttribute("searchForm");
List records=(List)request.getAttribute("biographies");
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
    out.write( (form.getOp_animname().indexOf("NULL")>-1 || form.getValue_animname()!=null)?", Animal Name "+form.getOp_animname()+(form.getValue_animname()!=null?" '"+form.getValue_animname()+"'":""):"" );
    out.write( (form.getOp_birthgroup().indexOf("NULL")>-1 || form.getValue_birthgroup()!=null)?", Birth Group "+form.getOp_birthgroup()+(form.getValue_birthgroup()!=null?" '"+form.getValue_birthgroup()+"'":""):"" );
    out.write( (form.getOp_bgqual().indexOf("NULL")>-1 || form.getValue_bgqual()!=null)?", Certainty of Birth Group "+form.getOp_bgqual()+(form.getValue_bgqual()!=null?" '"+form.getValue_bgqual()+"'":""):"" );
    out.write( (form.getOp_sex().indexOf("NULL")>-1 || form.getValue_sex()!=null)?", Sex "+form.getOp_sex()+(form.getValue_sex()!=null?" '"+form.getValue_sex()+"'":""):"" );
    out.write( (form.getOp_momid().indexOf("NULL")>-1 || form.getValue_momid()!=null)?", Mom "+form.getOp_momid()+(form.getValue_momid()!=null?" '"+form.getValue_momid()+"'":""):"" );
    out.write( (form.getOp_firstborn().indexOf("NULL")>-1 || form.getValue_firstborn()!=null)?", Is First Born "+form.getOp_firstborn()+(form.getValue_firstborn()!=null?" '"+form.getValue_firstborn()+"'":""):"" );
    out.write( (form.getOp_birthdate().indexOf("NULL")>-1 || form.getValue_birthdate()!=null)?", Birth Date "+form.getOp_birthdate()+(form.getValue_birthdate()!=null?" '"+form.getValue_birthdate()+"'":""):"" );
    out.write( (form.getOp_bdmin().indexOf("NULL")>-1 || form.getValue_bdmin()!=null)?", Min Birth Date "+form.getOp_bdmin()+(form.getValue_bdmin()!=null?" '"+form.getValue_bdmin()+"'":""):"" );
    out.write( (form.getOp_bdmax().indexOf("NULL")>-1 || form.getValue_bdmax()!=null)?", Max Birth Date "+form.getOp_bdmax()+(form.getValue_bdmax()!=null?" '"+form.getValue_bdmax()+"'":""):"" );
    out.write( (form.getOp_bddist().indexOf("NULL")>-1 || form.getValue_bddist()!=null)?", Birth Date Distribution "+form.getOp_bddist()+(form.getValue_bddist()!=null?" '"+form.getValue_bddist()+"'":""):"" );
    
    out.write( (form.getOp_entrydate().indexOf("NULL")>-1 || form.getValue_entrydate()!=null)?", Entry Date "+form.getOp_entrydate()+(form.getValue_entrydate()!=null?" '"+form.getValue_entrydate()+"'":""):"" );
    out.write( (form.getOp_entrytype().indexOf("NULL")>-1 || form.getValue_entrytype()!=null)?", Entry Type "+form.getOp_entrytype()+(form.getValue_entrytype()!=null?" '"+form.getValue_entrytype()+"'":""):"" );
    out.write( (form.getOp_departdate().indexOf("NULL")>-1 || form.getValue_departdate()!=null)?", Depart Date "+form.getOp_departdate()+(form.getValue_departdate()!=null?" '"+form.getValue_departdate()+"'":""):"" );
    out.write( (form.getOp_departdateerror().indexOf("NULL")>-1 || form.getValue_departdateerror()!=null)?", Depart Date Error "+form.getOp_departdateerror()+(form.getValue_departdateerror()!=null?" '"+form.getValue_departdateerror()+"'":""):"" );
    out.write( (form.getOp_departtype().indexOf("NULL")>-1 || form.getValue_departtype()!=null)?", Depart Type "+form.getOp_departtype()+(form.getValue_departtype()!=null?" '"+form.getValue_departtype()+"'":""):"" );
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