<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>   
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/fmt.tld"%>
<%@ page import="org.nescent.plhdb.util.NoCache" %>


<%       
NoCache.nocache(response);
Character M=new Character('M');
Character F=new Character('F');
Character U=new Character('U');
Character Y=new Character('Y');
Character N=new Character('N');
Character C=new Character('C');
request.setAttribute("M",M);
request.setAttribute("F",F);
request.setAttribute("U",U);
request.setAttribute("Y",Y);
request.setAttribute("N",N);
request.setAttribute("C",C);
%>
<style type="text/css">

html, body { height: 100%; width: 100%; padding: 0; border: 0; }
#main { height: 650px; width: 100%; padding: 0; border: 0; background-color: #fafafa; }
#list1, #list2,#list3 {width:100px; background-color: #ededed;padding:0px;} 
#header, #mainSplit { margin: 10px;}
#selected {background-color: #629FDD;
color: #FFFFFF;
font-weight: bold; }
/* pre-loader specific stuff to prevent unsightly flash of unstyled content */
#loader { 
	padding:0;
	margin:0;
	/*
	position:absolute; 
	top:180px; left:0px;  
	width:100%;
	height:100%;  
	*/
    background:#fafafa; 
	z-index:999;
	vertical-align:center; 
    text-align: center;
}
#loaderInner {
	padding:5px;
	position:relative; 
	left:0;
	top:0; 		
	width:175px; 
	 
	color:#ff0000; 			
	
}


hr.spacer { border:0; background-color:#ededed; width:80%; height:1px; } 
</style>

<script language="javascript">
dojo.require("dojo.parser");
dojo.require("dijit._Calendar");
dojo.require("dijit.form.FilteringSelect");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.ComboBox");
dojo.require("dijit.layout.ContentPane");
dojo.require("dijit.layout.SplitContainer");
dojo.require("dijit.layout.TabContainer");
dojo.require("dijit.layout.LayoutContainer");
dojo.require("dijit.dijit");
dojo.require("dijit.Dialog");

var start_types=new Array();
start_types[0]="beginning of observation";
start_types[1]="birth";
start_types[2]="confirmed identification";
start_types[3]="immigration into population";

var start_type_codes=new Array();
start_type_codes[0]="O";
start_type_codes[1]="B";
start_type_codes[2]="C";
start_type_codes[3]="I";

var stop_types=new Array();
stop_types[0]="";
stop_types[1]="death";
stop_types[2]="emigration from population";
stop_types[3]="end of observation";
stop_types[4]="permanent disappearance";
var stop_type_codes=new Array();
stop_type_codes[0]="";
stop_type_codes[1]="D";
stop_type_codes[2]="E";
stop_type_codes[3]="O";
stop_type_codes[4]="P";

var targetedObject;
var newid=0;
/*
var moms=new Array();
<c:forEach items="${moms}" var="mom" varStatus="status">
	moms[<c:out value='${status.count-1}'/>]="<c:out value='${mom.individualId}' />";
</c:forEach>
*/
function handleEnter (field, event) {
	var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
	if (keyCode == 13) {
		var i;
		for (i = 0; i < field.form.elements.length; i++)
			if (field == field.form.elements[i])
				break;
		i = (i + 1) % field.form.elements.length;
		field.form.elements[i].focus();
		//var theObj = document.getElementById("div_name_options");
		//theObj.style.visibility="hidden";
		return false;
	} 
	else
	return true;
}      


function addFertility(){
    var tb;
    var tr;
    var td_startdate;
    var td_starttype;
    var td_stopdate;
    var td_stoptype;
    var input_id=document.createElement("input");
    input_id.setAttribute("type","hidden");
    input_id.setAttribute("value",newid);
    input_id.setAttribute("name","newid"+newid);
    tb=document.getElementById("fertility_table");
    
    if(!dojo.isIE){
	
	
	tr=document.createElement("tr");
    	td_startdate=document.createElement("td");
   	td_starttype=document.createElement("td");
   	td_stopdate=document.createElement("td");
   	td_stoptype=document.createElement("td");
    } else{
	var lastRow = tb.rows.length;
	var iteration = lastRow;
	tr = tb.insertRow(lastRow);
	td_startdate=tr.insertCell(0);
   	td_starttype=tr.insertCell(1);
   	td_stopdate=tr.insertCell(2);
   	td_stoptype=tr.insertCell(3);
    }
    
    var startdate_id="newstartdate"+newid;
    td_startdate.setAttribute("class","TdValue");
    var input=document.createElement("input");
    //input.setAttribute("constraints", "{datePattern:'yyyy-MM-dd'}");
    input.setAttribute("name",startdate_id);
    input.setAttribute("id", startdate_id);
    input.setAttribute("size", "10");
    td_startdate.appendChild(input);
   
    
    
    //var dojoInput = dojo.widget.createWidget("dijit.form.DateTextBox", { constraints:{datePattern:'yyyy-MM-dd'}} , input);
    //td_startdate.appendChild(dojoInput.domNode);
    
    var stopdate_id="newstopdate"+newid;
    var input1=document.createElement("input");
    //input1.setAttribute("constraints", "{datePattern:'yyyy-MM-dd'}");
    input1.setAttribute("name",stopdate_id);
    input1.setAttribute("id", stopdate_id);
    input1.setAttribute("size", "10");
    
    td_stopdate.appendChild(input1);
     
    var id="newstarttype"+newid;
    var select=document.createElement("select");
    for(var i=0;i<start_types.length;i++){
	var opt=document.createElement("option");
	opt.appendChild(document.createTextNode(start_types[i]));
	opt.setAttribute("value",start_type_codes[i]);
	select.appendChild(opt);
    }
    select.setAttribute("name",id);
    select.setAttribute("id", id);
    td_starttype.appendChild(select);
    
    
    id="newstoptype"+newid;
    var select1=document.createElement("select");
    for(var i=0;i<stop_types.length;i++){
	var opt=document.createElement("option");
	opt.appendChild(document.createTextNode(stop_types[i]));
	opt.setAttribute("value",stop_type_codes[i]);
	select1.appendChild(opt);
    }
    select1.setAttribute("name",id);
    select1.setAttribute("id", id);
    td_stoptype.appendChild(select1);
    
    
    td_starttype.setAttribute("class","TdValue");
    td_startdate.setAttribute("class","TdValue");
    td_startdate.setAttribute("style","width:80px;");
    td_stopdate.setAttribute("class","TdValue");
    td_stopdate.setAttribute("style","width:80px;");
    td_stoptype.setAttribute("class","TdValue");
    tr.appendChild(input_id);
    if(!dojo.isIE){
	
	tr.appendChild(td_startdate);
	tr.appendChild(td_starttype);
	tr.appendChild(td_stopdate);
	tr.appendChild(td_stoptype);
	tb.appendChild(tr);
    }
    var parameters = {
	    constraints:{datePattern:'yyyy-MM-dd'}
            };
    /*
    var box=new dijit.form.DateTextBox(parameters, dojo.byId(startdate_id));
    box.domNode.setAttribute("name",startdate_id);
    box.domNode.setAttribute("style","width:80px;");
    box.startup();
    
    var box1=new dijit.form.DateTextBox(parameters, dojo.byId(stopdate_id));
    box1.domNode.setAttribute("name",stopdate_id);
    box1.domNode.setAttribute("style","width:80px;");
    box1.startup();
    */
    newid=newid+1;
    //dojo.parser.parse(dojo.byId(id)); 
}



function createDateTd(name){
    var id=name+newid;
    var td=document.createElement("td");
    td.setAttribute("class","TdValue");
    var input=document.createElement("input");
    input.setAttribute("dojoType","dijit.form.DateTextBox");
    input.setAttribute("constraints", "{datePattern:'yyyy-MM-dd'}");
    input.setAttribute("name",id);
    input.setAttribute("id", id);
    td.appendChild(input);
}

function entryDateTooClicked(){
    var addindividual_form=document.addindividual_form;
    addindividual_form.entrydate.value=addindividual_form.birthdate.value;
    dojo.byId("entrydate").setDate(new Date("2000, 10,10"));
}

function deleteData(dataEntity, id, studyid){
    if (confirm("Do you really want to delete the "+ dataEntity+"?")){ 
	if(confirm("You asked to delete the "+ dataEntity+" record. Please confirm that the record should be deleted. This operation cannot be undone.")){
	    var url="/delete/" + dataEntity +".go?studyid"+"="+studyid+"&"+dataEntity+"="+id;
	    window.location.href=url;
	}
    }
}
function removeBiography(id,studyid){
    if (confirm("You asked to remove a biography record. This will cause the biography and all fertility interval records of the animal to be deleted from the database, but the animal's offspring will retain it as the mother. Please confirm that the biography is to be removed.")){
	if(confirm("Please confirm again that the biography really should be removed. This operation cannot be undone.")) {
	    var url="/remove/biography.go?studyid"+"="+studyid+"&animoid="+id;
	    window.location.href=url;
	}
    }
}
function deleteFertilityData(dataEntity,animOid,id,studyid){
    if (confirm("Do you really want to delete the fertility record?")){
	if(confirm("You asked to delete a fertility interval. Please confirm that the fertility interval should be deleted. This operation cannot be undone.")){
	    var url="/delete/fertility.go?studyid"+"="+studyid+"&animOid="+animOid+"&fertility="+id;
	    window.location.href=url;
	}
    }
}

function hideLoader(){
	var loader = dojo.byId('loader'); 
	dojo.fadeOut({ node: loader, duration:10,
		onEnd: function(){ 
			loader.style.display = "none"; 
		}
	}).play();
}

function copyBirthDate(){
    var birtherror=document.getElementById("bderror");
    if(birtherror.value!=null && birtherror.value!="0.0")
    {
	alert("The entry date can not be the same as the birth date since the birth date error is not equal to 0");
	return;
    }
    var birth=document.getElementById("birthdate");
    var entrydate=document.getElementById("entrydate");
    var entrytype=document.getElementById("entrytype");
    entrydate.value=birth.value;
    entrytype.value="B";
    
}

function copyBirthDate1(){
    var birtherror=document.getElementById("bderror1");
    if(birtherror.value!=null && birtherror.value!="0.0")
    {
	alert("The entry date can not be the same as the birth date since the birth date error is not equal to 0");
	return;
    }
    var birth=document.getElementById("birthdate1");
    var entrydate=document.getElementById("entrydate1");
    var entrytype=document.getElementById("entrytype1");
    entrydate.value=birth.value;
    entrytype.value="B";
    
}
/*
var isNav = (navigator.appName.indexOf("Netscape")>=0);
var isIE=(navigator.appName.indexOf("Microsoft Internet Explore")>=0);	
var req=null;

function handleNameChanged(snames)
{
	var theObj = document.getElementById("div_name_options");
	
	var opts=document.getElementById("name_options");
	opts.options.length=0;

	var ind=0;
		
	var pos1=snames.indexOf("<name>");
				
	while(pos1>-1)
	{
		var pos2=snames.indexOf("</name>",pos1);
		if(pos2>-1)
		{
			var sname=snames.substring(pos1+6,pos2);
			opts.options[ind++]=new Option(sname,sname);	
		}
		
		pos1=snames.indexOf("<name>", pos2);
		
	}
		
	if(ind>0)
	{
		if (isNav)
		{
			if(theObj.style.visibility=="hidden") theObj.style.visibility="visible";
		}
	    else if (isIE)
	    {
	    	if(theObj.style.visibility=="hidden") theObj.style.visibility="visible";	  
	    }
		else
		{
			if(theObj.style.visibility=="hidden") theObj.style.visibility="visible";
		}
	}
	else
	{
		theObj.style.visibility="hidden";
	}

}



function trim(inputString)
{
	if (typeof inputString != "string") { return inputString; }
	var retValue = inputString;
	var ch = retValue.substring(0, 1);
	while (ch == " ")
	{ // Check for spaces at the beginning of the string
       retValue = retValue.substring(1, retValue.length);
       ch = retValue.substring(0, 1);
    }

  	ch = retValue.substring(retValue.length-1, retValue.length);
   	while (ch == " ")
   	{ // Check for spaces at the end of the string
      retValue = retValue.substring(0, retValue.length-1);
      ch = retValue.substring(retValue.length-1, retValue.length);
    }
   	while (retValue.indexOf("  ") != -1)
   	{ // Note that there are two spaces in the string - look for multiple spaces within the string
   	  retValue = retValue.substring(0, retValue.indexOf("  ")) + retValue.substring(retValue.indexOf("  ")+1, retValue.length); // Again, there are two spaces in each of the strings
   	}
    return retValue; // Return the trimmed string back to the user
} // Ends the "trim" function

function name_changed(obj)
{
	//alert("Is Nav:"+isNav+ " Is IE:"+isIE );

	var v=trim(obj.value).toUpperCase();
	var theObj = document.getElementById("div_name_options");
	
	var opts=document.getElementById("name_options");
	opts.options.length=0;
	
	var ind=0;
	var max=20;
	var count=0;	
	for(var i=0;i<moms.length;i++)
	{
		if(moms[i].toUpperCase().indexOf(v)>-1)
		{
			opts.options[ind++]=new Option(moms[i],moms[i]);	
			count++;
		}
		if(count==max)
			i=moms.length;
	}
		
	if(ind>0)
	{
		if (isNav)
		{
			if(theObj.style.visibility=="hidden") theObj.style.visibility="visible";
		}
	    else if (isIE)
	    {
	    	if(theObj.style.visibility=="hidden") theObj.style.visibility="visible";	  
	    }
		else
		{
			if(theObj.style.visibility=="hidden") theObj.style.visibility="visible";
		}
	}
	else
	{
		theObj.style.visibility="hidden";
	}
	var pos=findPos(targetedObject);
	theObj.style.left=pos[0]+"px";
	theObj.style.top=pos[1]+25+"px";

}


function name_selected()
{
	var theObj = document.getElementById("div_name_options");
	var opts=document.getElementById("name_options");
	var name=opts.value;

	if(name!=null && name!="") targetedObject.value=name;	

	
	theObj.style.visibility="hidden";
	
}
function findPos(obj) {
	var curleft = curtop = 0;
	if (obj.offsetParent) {
		curleft = obj.offsetLeft
		curtop = obj.offsetTop
		while (obj = obj.offsetParent) {
			curleft += obj.offsetLeft
			curtop += obj.offsetTop
		}
	}
	return [curleft,curtop];
}

function getkey(e)
{
	if (window.event)
		return window.event.keyCode;
	else if (e)
		return e.which;
	else
		return null;
}

function key_pressed(e,obj)
{
    targetedObject=obj;
	var theObj = document.getElementById("div_name_options");
    var opts=document.getElementById("name_options");

	var key=getkey(e);
//	alert(key);
	
	if(key==40) //next
	{
	    if(theObj.style.visibility =="hidden")
		    show_select_names();
		  //  name_changed(obj);
		var l=opts.options.length-1;
		if(l>-1)
		{
			if(opts.options.selectedIndex==-1)
				opts.options[0].selected=true;
			else if(opts.options.selectedIndex==l)
				opts.options[0].selected=true;
			else 
				opts.options[opts.options.selectedIndex+1].selected=true;
			
	
			document.queryFloraShow.taxon_name.value=opts.options[opts.options.selectedIndex].value;
		}	
	}
	else if(key==38) //upper
	{
		if(theObj.style.visibility =="hidden")
			show_select_names();

		//    name_changed(obj);
		

		var l=opts.options.length-1;
		if(l>-1)
		{
			if(opts.options.selectedIndex==-1)
				opts.options[0].selected=true;
			else if(opts.options.selectedIndex==0)
				opts.options[l].selected=true;
			else 
				opts.options[opts.options.selectedIndex-1].selected=true;
				
			document.biography_form.momid1.value=opts.options[opts.options.selectedIndex].value;
		}    

	}
	else if(key==13)
	{
		
		theObj.style.visibility="hidden";
		return false;
		
	}
	else
	{
		name_changed(obj);		
	}
	
}

function hide_select_names()
{
	var theObj = document.getElementById("div_name_options");
	theObj.style.visibility="hidden";
}

function show_select_names()
{
	//var t=parent.TopFrame;
	var theObj = document.getElementById("div_name_options");

	if (isNav)
	{
		if(theObj.style.visibility=="hidden") theObj.style.visibility="show";
	}
	if (isIE)
	{
		if(theObj.style.visibility=="hidden") theObj.style.visibility="visible";	  
	}
	else
	{
		if(theObj.style.visibility=="hidden") theObj.style.visibility="show";
	}
}
*/
dojo.addOnLoad(function() {

	dojo.parser.parse(dojo.byId('container')); 
//	dojo.byId('loaderInner').innerHTML += " done.";
//	setTimeout("hideLoader()",10);
			
});


</script>
<div id="div_name_options" style="position:absolute; overflow:hidden; left:466px; top:363px; width:450px; height:175px; z-index:1; visibility:hidden">
<select id="name_options" size="10" onclick="javascript:name_selected()">
</select>
</div>

<!-- div id="loader"><div id="loaderInner">Loading data ... </div></div -->

	<div id="main" dojoType="dijit.layout.LayoutContainer">
		<h1 id="header" dojoType="dijit.layout.ContentPane" layoutAlign=top>Edit Data</h1>
	
		<!-- overall splitcontainer horizontal -->
		<div dojoType="dijit.layout.SplitContainer" orientation="horizontal" sizerWidth="7"
			layoutAlign=client id="mainSplit">
			<div id="list1" dojoType="dijit.layout.ContentPane" title="Taxon" style="padding:2px;border: 1px;solid;#445;">
				<h2>Study/Species&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:dijit.byId('addstudy_dialog').show()">add</a></h2>
				<table>
					<c:forEach items="${studies}" var="study">
        				<tr><td>
        				<c:choose>
        				<c:when test='${currentStudy.studyId==study.studyId}'>
        				<span id="selected"><c:out value='${study.studyId}' />(<c:out value='${study.sciname}' />)</span>
        				</c:when>
        				<c:otherwise>
        					<a href="/edit.go?studyid=<c:out value='${study.studyId}' />"><c:out value='${study.studyId}' />(<c:out value='${study.sciname}' />)</a>
        					</c:otherwise>
        						</c:choose>
        					</td></tr>
        			    	</c:forEach>
        			
        			</table>
			</div>
		<div id="list3" dojoType="dijit.layout.ContentPane" title="Individual" style="padding:2px;border: 1px;solid;#445;">
			<h2>Individuals&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:dijit.byId('addindividual_dialog').show()">add</a></h2>
			<table>
			<c:forEach items="${individuals}" var="individual">
				<tr><td>
				<c:choose>
				<c:when test='${currentIndividual.animid==individual.animid}'>
					<span id="selected"><c:out value='${individual.animid}' /></span>
				</c:when>
				<c:otherwise>
					<a href="/edit.go?studyid=<c:out value='${currentStudy.studyId}' />&individual=<c:out value='${individual.animOid}' />"><c:out value='${individual.animid}' /></a>
				</c:otherwise>
				</c:choose>
			    </td></tr>
			</c:forEach>
			
			</table>
		</div>
			<div dojoType="dijit.layout.TabContainer" sizeShare="40">
			<!-- study tab -->
			<c:choose>
				<c:when test='${tab==null || tab=="study"}'>
					<div id="tab0" dojoType="dijit.layout.ContentPane" title="Study" style="padding:10px;" selected="true">
				</c:when>
				<c:otherwise>
					<div id="tab0" dojoType="dijit.layout.ContentPane" title="Study" style="padding:10px; display:none;">
				</c:otherwise>
			</c:choose>
				<c:if test='${currentStudy!=null}'>
				<p>Most recent end date: <fmt:formatDate value='${recentEndDate}' type='both' pattern='dd-MMM-yyyy' /></p>
				<form action="/save/study.go" method="post" name="study_form">
				
				<input type="hidden" name="studyName" value="<c:out value='' />" />
				<input type="hidden" name="studyid" value="<c:out value='${currentStudy.studyId}' />" />
				<table>
				<tr><td class="TdField">Study Id</td><td class="TdValue">
					<c:out value='${currentStudy.studyId}' />
				</td></tr>
				
				<tr><td class="TdField">owners</td><td class="TdValue">
				<input name="owners" value="<c:out value='${currentStudy.owners}' />"  onkeypress="return handleEnter(this, event)" />
				</td></tr>
				
				<tr><td class="TdField required">Scientific Name</td><td class="TdValue">
					<input name="scientificName" value="<c:out value='${currentStudy.sciname}' />"  onkeypress="return handleEnter(this, event)"/>
				</td></tr>
				<tr><td class="TdField">Common Name</td><td class="TdValue">
					<input name="commonName" value="<c:out value='${currentStudy.commonname}' />"  onkeypress="return handleEnter(this, event)"/>
				</td></tr>
				<tr><td class="TdField required">Site</td><td class="TdValue">
					<input name="siteName" value="<c:out value='${currentStudy.siteid}' />"  onkeypress="return handleEnter(this, event)"/>
				</td></tr>
				<tr><td class="TdField">Latitude</td><td class="TdValue">
					<input name="latitude" value="<c:out value='${currentStudy.latitude}' />"  onkeypress="return handleEnter(this, event)"/>
				</td></tr>
				<tr><td class="TdField">Longitude</td><td class="TdValue">
					<input name="longitude" value="<c:out value='${currentStudy.longitude}' />"  onkeypress="return handleEnter(this, event)"/>
				</td></tr>
				<tr><td class="TdField required">Required Field</td><td class="TdValue"><td></tr>
				
				

				<tr><td /><td>&nbsp;</td></tr>
				<tr><td>
				<input type="submit" value="save" /></td><td><span class ="abutton"><a href="javascript: deleteData('study','<c:out value='${currentStudy.studyId}' />','<c:out value='${currentStudy.studyId}' />')">delete</a></span>
				</td></tr>
				</table>
				</form>
				</c:if>
			</div><!-- end study tab -->
			<!-- biography tab -->
			<c:choose>
				<c:when test='${tab=="biography"}'>
					<div id="tab1" dojoType="dijit.layout.ContentPane" title="Biography" style="padding:10px;" selected="true">
				</c:when>
				<c:otherwise>
					<div id="tab1" dojoType="dijit.layout.ContentPane" title="Biography" style="padding:10px; display:none;">
				</c:otherwise>
			</c:choose>
				
			<c:if test='${currentIndividual!=null}'>
				<form action="/save/biography.go" method="post" name="biography_form">
				<input type="hidden" name="studyid" value="<c:out value='${currentStudy.studyId}' />" />
				<input type="hidden" name="individual_id" value="<c:out value='${currentIndividual.animOid}' />" />
				<table>
				
				<tr><td class="TdField required">Study</td><td class="TdValue">
				<select  name="studyid1"  onkeypress="return handleEnter(this, event)">
					<c:forEach items="${studies}" var="study">
						<c:choose>
						<c:when test='${study.studyId==currentIndividual.studyid}'>
							<option selected value="<c:out value='${study.studyId}' />"><c:out value='${study.studyId}' /></option>
						</c:when>
						<c:otherwise>
							<option value="<c:out value='${study.studyId}' />"><c:out value='${study.studyId}' /></option>
						</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
				</td></tr>
				<tr><td class="TdField">Individual Name</td><td class="TdValue"><input name="individualname1" type="text" value="<c:out value='${currentIndividual.animname}' />"  onkeypress="return handleEnter(this, event)"/></td></tr>
				<tr><td class="TdField required">Individual ID</td><td class="TdValue"><input name="individualid1" type="text" value="<c:out value='${currentIndividual.animid}' />"  onkeypress="return handleEnter(this, event)"/></td></tr>
				<tr><td class='TdField'>Birth Group</td><td class='TdValue'><input type='text' name='birthgroup1' value="<c:out value='${currentIndividual.birthgroup}' />"  onkeypress="return handleEnter(this, event)"/></td></tr>
				<tr><td class="TdField">Birth Group Certainty</td><td class="TdValue">
				<select name="birthgroupcertainty1"  onkeypress="return handleEnter(this, event)">
				<option value=""></option>
				<c:choose>	
					<c:when test='${currentIndividual.bgqual==C}' >
						<option selected value="C">Certain</option>
						<option value="U">Uncertain</option>
					</c:when>
					<c:when test='${currentIndividual.bgqual==U}' >
						<option value="C">Certain</option>
						<option selected value="U">Uncertain</option>
					</c:when>
					<c:otherwise>
						<option	value="C">Certain</option>
						<option value="U">Uncertain</option>
					</c:otherwise>
				</c:choose>
			    	</select>
			    	</td></tr>
				<tr><td class="TdField required">Sex</td><td class="TdValue">
				<select name="sex1"  onkeypress="return handleEnter(this, event)">
				<option value=""></option>  
				    <c:choose>
				    	<c:when test="${currentIndividual.sex==M}">
				    		<option selected value="M">Male</option>
				    		<option value="F">Female</option>
				    		<option value="U">Unknown</option>
				    	</c:when>
				    	<c:when test='${currentIndividual.sex==F}'>
        			    		<option value="M">Male</option>
        			    		<option selected value="F">Female</option>
        			    		<option value="U">Unknown</option>
        			    	</c:when>
        			    	<c:when test='${currentIndividual.sex==U}'>
                		    		<option value="M">Male</option>
                		    		<option value="F">Female</option>
                		    		<option selected value="U">Unknown</option>
                		    	</c:when>
                		    	<c:otherwise>
        		    			<option value="M">Male</option>
        		    			<option value="F">Female</option>
        		    			<option value="U">Unknown</option>
        		    		</c:otherwise>
				    </c:choose>
			    	</select>
			    	</td></tr>
				<tr><td class='TdField'>Mom</td><td class='TdValue'>
					<input type="text" name="momid1" id="momid1" value="<c:out value='${currentIndividual.momid}' />" onkeypress="return handleEnter(this, event)"/>
				</td></tr>
				<tr><td class="TdField required">Is First Born</td><td class="TdValue">
				<select name="isfirstborn1"  onkeypress="return handleEnter(this, event)">
					<option value=""></option>    
					<c:choose>
				    	<c:when test='${currentIndividual.firstborn==Y}'>
				    		<option selected value="Y">Yes</option>
					    	<option value="N">No</option>
					    	<option value="U">Unknown</option>
				    	</c:when>
				    	<c:when test='${currentIndividual.firstborn==N}'>
				    		<option value="Y">Yes</option>
				    		<option selected value="N">No</option>
				    		<option value="U">Unknown</option>
        			    	</c:when>
        			    	<c:when test='${currentIndividual.firstborn==U}'>
        			    		<option value="Y">Yes</option>
        			    		<option value="N">No</option>
        			    		<option selected value="U">Unknown</option>
                		    	</c:when>
                		    	<c:otherwise>
                		    		<option value="Y">Yes</option>
                		    		<option value="N">No</option>
                		    		<option value="U">Unknown</option>
        		    		</c:otherwise>
				    </c:choose>
					
			    	</select>
			    	</td></tr>
				<tr><td class='TdField required'>Birth Date(dd-MMM-yyyy)</td><td class='TdValue'><input type="text" name='birthdate1' id="birthdate1" value="<fmt:formatDate value='${currentIndividual.birthdate}' type='both' pattern='dd-MMM-yyyy' />" onkeypress="return handleEnter(this, event)"/></td></tr>
				<tr><td class='TdField'>Min Birth Date(dd-MMM-yyyy)</td><td class='TdValue'><input type="text" name='bdmin1' id="bdmin1" value="<fmt:formatDate value='${currentIndividual.bdmin}' type='both' pattern='dd-MMM-yyyy' />" onkeypress="return handleEnter(this, event)"/></td></tr>
				<tr><td class='TdField'>Max Birth Date(dd-MMM-yyyy)</td><td class='TdValue'><input type="text" name='bdmax1' id="bdmax1" value="<fmt:formatDate value='${currentIndividual.bdmax}' type='both' pattern='dd-MMM-yyyy' />" onkeypress="return handleEnter(this, event)"/></td></tr>
				<tr><td class='TdField'>Birth Date Distribution</td><td class='TdValue'>
				<select name="bddist1"  onkeypress="return handleEnter(this, event)">
				<c:forEach items="${sessionScope.bddist_cvterms}" var="cvterm">
				    
				    	<c:choose>
				    	<c:when test='${cvterm.code==currentIndividual.bddist}'>	
				    		<option selected value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
				    	</c:when>
				    	<c:otherwise>
				    		<option value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
				    	</c:otherwise>
				    	</c:choose>
				    	
				</c:forEach>
				</select>
				</td></tr>
				<tr><td class='TdField required'>Entry Date(dd-MMM-yyyy)</td><td class='TdValue'><input type="text" name='entrydate1' id="entrydate1"  value="<fmt:formatDate value='${currentIndividual.entrydate}' type='both' pattern='dd-MMM-yyyy' />" onkeypress="return handleEnter(this, event)" />
				</td></tr>
				<tr><td class='TdField required'>Entry Type</td><td class='TdValue'>
				<select name="entrytype1"  onkeypress="return handleEnter(this, event)">
				<c:forEach items="${sessionScope.start_cvterms}" var="cvterm">
				    
				    	<c:choose>
				    	<c:when test='${cvterm.code==currentIndividual.entrytype}'>	
				    		<option selected value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
				    	</c:when>
				    	<c:otherwise>
				    		<option value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
				    	</c:otherwise>
				    	</c:choose>
				    	
				</c:forEach>
				</select>
				</td></tr>
				<tr><td class='TdField required'>Depart Date(dd-MMM-yyyy)</td><td class='TdValue'><input type="text" name='departdate1' id="departdate1" value="<fmt:formatDate value='${currentIndividual.departdate}' type='both' pattern='dd-MMM-yyyy' />" onkeypress="return handleEnter(this, event)"/></td></tr>
				<tr><td class='TdField'>Depart Date Error</td><td class='TdValue'><input type='text' name='departdateerror1'  value="<c:out value='${currentIndividual.departdateerror}' />"  onkeypress="return handleEnter(this, event)"/></td></tr>
				<tr><td class='TdField required'>Depart Type</td><td class='TdValue'>
				<select name="departtype1"  onkeypress="return handleEnter(this, event)">
				<option value=""></option>
				<c:forEach items="${sessionScope.stop_cvterms}" var="cvterm">
				    	
				    <c:choose>
				    	<c:when test='${cvterm.code==currentIndividual.departtype}'>		
				    		<option selected value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
				    	</c:when>
					<c:otherwise>
						<option value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
					</c:otherwise>
					</c:choose>
				    	
				</c:forEach>
				</select>
				</td></tr>
				<tr><td class="TdField required">Required Field</td><td class="TdValue"><td></tr>
				<tr><td /><td>&nbsp;</td></tr>
                                <tr><td>
                                <input type="submit" value="save" /></td><td>
                                <table><tr><td class ="abutton"><a href="javascript: deleteData('individual','<c:out value='${currentIndividual.animOid}' />', '<c:out value='${currentStudy.studyId}' />')">delete</a></td>
                                <td>&nbsp;&nbsp;</td>
                                <td class="abutton">
                                <a href="javascript: removeBiography('<c:out value='${currentIndividual.animOid}' />','<c:out value='${currentStudy.studyId}' />')">remove from biography</a>
                                </td></tr></table>
                                </td></tr>
                              	</table>
                                </form>
                              </c:if>

			</div><!-- end:biography tab -->
					<!-- fertility tab -->
					<c:choose>
					<c:when test='${tab=="fertility"}'>
						<div id="tab2" dojoType="dijit.layout.ContentPane" title="Fertility" style="padding:10px;" selected="true">
					</c:when>
					<c:otherwise>
						<div id="tab2" dojoType="dijit.layout.ContentPane" title="Fertility" style="padding:10px; display:none;">
					</c:otherwise>
					</c:choose>
					
						<c:if test='${currentIndividual!=null}'>
						<form action="/save/fertilities.go" method="post" name="fertility_form">
						    <input type="hidden" name="studyid" value="<c:out value='${currentStudy.studyId}' />" />
						<input type="hidden" name="individual_id" value="<c:out value='${currentIndividual.animOid}' />" />
						<table id="fertility_table">
						
						<tr>
						
						<td class="TdHead">Start Date<br>(dd-MMM-yyyy)</td>
						<td class="TdHead">Start Type</td>
						<td class="TdHead">End Date<br/>(dd-MMM-yyyy)</td>
						<td class="TdHead">End Type</td>
						<td class="TdHead">Action</td>
						</tr>
						<c:forEach items="${fertilities}" var="fertility" varStatus="status">
						<input type="hidden" name="id<c:out value='${fertility.intervalOid}' />" value="<c:out value='${fertility.intervalOid}' />" />
						<tr class="TdField">
						<td class="TdValue">
							<input  type="text" style="width:90px;" name="startdate<c:out value='${fertility.intervalOid}' />" value="<fmt:formatDate value='${fertility.startdate}' type='both' pattern='dd-MMM-yyyy' />"  onkeypress="return handleEnter(this, event)"/>
						</td>
						<td class="TdValue narrow">
							<select width="50" type="text" name="starttype<c:out value='${fertility.intervalOid}' />"  onkeypress="return handleEnter(this, event)">
							<c:forEach items="${sessionScope.start_cvterms}" var="cvterm">
							    	<c:choose>
							    		<c:when test='${cvterm.code==fertility.starttype}'>
							    			<option selected value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
							    		</c:when>
							    		<c:otherwise>
							    			<option value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
							    		</c:otherwise>
							    	</c:choose>
							    	
							</c:forEach>
							</select>	
						</td>
						<td class="TdValue">
							<input  type="text"  style="width:90px;" name="stopdate<c:out value='${fertility.intervalOid}' />" value="<fmt:formatDate value='${fertility.stopdate}' type='both' pattern='dd-MMM-yyyy' />"  onkeypress="return handleEnter(this, event)"/>
						</td>
						<td class="TdValue">
						<select type="text" name="stoptype<c:out value='${fertility.intervalOid}' />" onkeypress="return handleEnter(this, event)">
						<option selected value=""></option>
						<c:forEach items="${sessionScope.stop_cvterms}" var="cvterm">
						    <c:choose>
						    <c:when test='${cvterm.code==fertility.stoptype}'>
						    	<option selected value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
						    </c:when>
						    <c:otherwise>
						    	<option value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
						    </c:otherwise>
						    </c:choose>
						</c:forEach>
						</select>
						</td>
						<td><a href="javascript: deleteFertilityData('fertility','<c:out value='${currentIndividual.animOid}'/>', '<c:out value='${fertility.intervalOid}'/>','<c:out value='${currentStudy.studyId}' />')">delete</a></td>
						</tr>
						</c:forEach>
						
						</table>
						<br/>
						<span><input type="submit" value="save" />&nbsp;&nbsp;<a href="javascript: addFertility();">add</a></span>
						
						</form>
						</c:if>
					</div><!-- end fertility tab -->
				</div><!-- end tab container -->
		</div><!-- splitContainer parent -->
	</div><!-- Layoutcontainer -->
	
	<div id="addstudy_dialog" dojoType="dijit.Dialog" title="Add Study" style="display:none;">
	<form action="/add/study.go" name="addstudy_form" method="post">
	<table>
		<tr><td class="TdField">Study Name</td><td class="TdValue"><input name="studyName" type="text" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
		<tr><td class="TdField required">Study ID</td><td class="TdValue"><input name="studyId" type="text" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
		
		<tr><td class="TdField">Owners</td><td class="TdValue">
		<input type="text" name="owners"  onkeypress="return handleEnter(this, event)"/>
		</td></tr>
		<tr><td class="TdField required">Scientific Name</td><td class="TdValue"><input name="scientificName" type="text" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
		<tr><td class="TdField">Common Name</td><td class="TdValue"><input name="commonName" type="text" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
		
		<tr><td colspan=2>Site</td></tr>
		<tr><td class="TdField required">Site Name</td><td class="TdValue"><input name="siteName" type="text" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
		<tr><td class="TdField">Latitude</td><td class="TdValue"><input name="latitude" type="text" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
		<tr><td class="TdField">Longitude</td><td class="TdValue"><input name="longitude" type="text" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
		<tr><td class="TdField required">Required Field</td><td class="TdValue"><td></tr>
		
		
		<tr><td class="TdField"></td><td class="TdValue"><input type="submit" value="add" /></td></tr>
		
	</table>
	</form>
	</div>
	
	
	<div id="addindividual_dialog" dojoType="dijit.Dialog" title="Add Individual" style="display:none;">
	
		<form action="/add/individual.go" name="addindividual_form" method="post">
		<input type="hidden" name="studyid" value="<c:out value='${currentStudy.studyId}' />" />
			<table>
			<tr><td class="TdField required">Study</td><td class="TdValue">
				<select id="studyid"   name="studyid"  onkeypress="return handleEnter(this, event)">
					<c:forEach items="${studies}" var="study">
						<c:choose>
							<c:when test='${currentStudy.studyId==study.studyId}'>
								<option value="<c:out value='${study.studyId}' />" selected><c:out value='${study.studyId}' /></option>
							</c:when>
							<c:otherwise>
								<option value="<c:out value='${study.studyId}' />"><c:out value='${study.studyId}' /></option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			</td></tr>
			<tr><td class="TdField">Individual Name</td><td class="TdValue"><input name="individualname" type="text" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
			<tr><td class="TdField required">Individual ID</td><td class="TdValue"><input name="individualid" type="text" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
			<tr><td class="TdField">Birth Group</td><td class="TdValue"><input type="text" name="birthgroup" value=""  onkeypress="return handleEnter(this, event)"/></td></tr>
			<tr><td class="TdField">Birth Group Certainty</td><td class="TdValue">
				<select name="birthgroupcertainty" onkeypress="return handleEnter(this, event)">
					<option value=""></option>      
					<option value="C">Certain</option>
					<option value="U">Uncertain</option>
				</select>
			</td></tr>
			<tr><td class="TdField required">Sex</td><td class="TdValue">
				<select name="sex" onkeypress="return handleEnter(this, event)">
				<option value="M">Male</option>
				<option value="F">Female</option>
				<option value="U">Unknown</option>
				</select>
			</td></tr>
			<tr><td class="TdField">Mom</td><td class="'TdValue">
			<input type="text" name="momid" id="momid" onkeypress="return handleEnter(this, event)"/>
			</td></tr>
			<tr><td class="TdField  required">Is First Born</td><td class="TdValue">
			<select name="isfirstborn" onkeypress="return handleEnter(this, event)">
			<option value="Y">Yes</option>
			<option value="N">No</option>
			<option value="U">Unknown</option>
			</select>
			</td></tr>
			<tr><td class="TdField  required">Birth Date(dd-MMM-yyyy)</td><td class="TdValue">
			<input id="birthdate" type="text" name="birthdate"  onkeypress="return handleEnter(this, event)"/>
			</td></<tr><td class='TdField'>Min Birth Date(dd-MMM-yyyy)</td><td class='TdValue'><input type="text" name='bdmin' id="bdmin" type='both' pattern='dd-MMM-yyyy' onkeypress="return handleEnter(this, event)"/></td></tr>
			<tr><td class='TdField'>Max Birth Date(dd-MMM-yyyy)</td><td class='TdValue'><input type="text" name='bdmax' id="dbmax" type='both' pattern='dd-MMM-yyyy' onkeypress="return handleEnter(this, event)"/></td></tr>
			<tr><td class='TdField'>Birth Date Distribution</td><td class='TdValue'>
			<select name="bddist"  onkeypress="return handleEnter(this, event)">
			<c:forEach items="${sessionScope.bddist_cvterms}" var="cvterm">
			   		<option value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
			</c:forEach>
			</select>
			</td></tr>
                	<tr><td class="TdField required">Entry Date(dd-MMM-yyyy)</td><td class="TdValue">
                		<input id="entrydate" type="text" name="entrydate"  onkeypress="return handleEnter(this, event)"/>
                	</td></tr>
                	<tr><td class="TdField required">Entry Type</td><td class="TdValue">
                	<select name="entrytype" onkeypress="return handleEnter(this, event)">
                	<c:forEach items="${sessionScope.start_cvterms}" var="cvterm">
                	    	<option value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
                	</c:forEach>
                	</select>
                	</td></tr>
                	<tr><td class="TdField required">Depart Date(dd-MMM-yyyy)</td><td class="TdValue">
                		<input type="text" name="departdate" id="departdate"  onkeypress="return handleEnter(this, event)"/>
                	</td></tr>
                	<tr><td class="TdField">Depart Date Error</td><td class="TdValue">
                		<input type="text" name="departdateerror"  onkeypress="return handleEnter(this, event)"/>
                	</td></tr>
                	<tr><td class="TdField required">Depart Type</td><td class="TdValue">
                	<select name="departtype" onkeypress="return handleEnter(this, event)">
                	<option value=""></option>
                	<c:forEach items="${sessionScope.stop_cvterms}" var="cvterm">
                	    	<option value="<c:out value='${cvterm.code}' />"><c:out value='${cvterm.name}' /></option>
                	</c:forEach>
                	</select>
                	</td></tr>	
                	<tr><td class="TdField required">Required Field</td><td class="TdValue"><td></tr>
                	<tr><td class="TdField"></td><td class="TdValue">
                		<input type="submit" value="add" />
                	</td></tr>
                </table>
                </form>
	</div>



	
