<%@ page contentType="text/html" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/fmt.tld"%>
<%@ page import = "java.util.*" %> 

<script type="text/javascript">
function selectAll() {
	for (var i=0; i<document.selectform.elements.length; i++) {
		var e = document.selectform.elements[i];
		if (e.name.indexOf('show') == 0) e.checked = document.selectform.selectall.checked;
	}
}
function searchDistributionClicked() {
	for (var i=0; i<document.selectform.elements.length; i++) {
		var e = document.selectform.elements[i];
		if (e.name.indexOf('show') == 0) e.checked = !document.selectform.searchDistribution.checked;
	}
	document.selectform.selectall.checked=!document.selectform.searchDistribution.checked;
	document.selectform.selectall.disabled=document.selectform.searchDistribution.checked;
	var th=document.getElementById("thShow");
	var lbl="Show";
	if(document.selectform.searchDistribution.checked){
	    lbl="Group By";
	}
	var l=document.createTextNode(lbl);
	th.replaceChild(l,th.firstChild);
}

function clearForm(oForm){
	var frm_elements = oForm.elements; 
	for(i=0; i<frm_elements.length; i++) {

		field_type = frm_elements[i].type.toLowerCase();

		switch(field_type) {

		case "text":
		case "password":
		case "textarea":
		case "hidden":

		elements[i].value = "";
		break;

		case "radio":
		case "checkbox":

		if (elements[i].checked) {

		elements[i].checked = false;

		}
		break;

		case "select-one":
		case "select-multi":

		elements[i].selectedIndex = -1;
		break;

		default:
		break;

		}

		} 
}

</script>
<h2>Search Biography</h2>
<form action="/search/biography.go" method="post" name="selectform">
<table>
<tr><td colspan="5"><input type="checkbox" id="searchDistribution" name="searchDistribution" onClick="javascript:searchDistributionClicked()" /><label for="searchDistribution">Search Distribution</label><br/>
Check 'Search Distribution' to get a summary result of data records distribution according to the fields you choose below. For example, you can get a sex distribution by ckecking the sex field. The distribution 
search can also be combined with filtering conditions, such as sex distribution for all animals that have a depart type of 'death'.</td>
<tr><tr><th id="thShow" name="thShow">Show</th><th>Column</th><th>Operator</th><th>Value</th></tr>
<tr><td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_studyid" /></td><td class="odd" nowrap="nowrap">Study/Species</td><td class="odd" nowrap="nowrap"><select name="op_studyid">
<option value="=">=</option>
<option value="!=">!=</option>
</select>
</td>
<td class="odd" nowrap="nowrap"><input type="text"  name="value_studyid" size="50">
</td></tr>
<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_animid" /></td><td class="even" nowrap="nowrap">Animal Id</td><td class="even" nowrap="nowrap"><select name="op_animid">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="LIKE">LIKE</option>
<option value="NOT LIKE">NOT LIKE</option>
<option value="ILIKE">ILIKE</option>
<option value="NOT ILIKE">NOT ILIKE</option>
<option value="IN">IN</option>
<option value="NOT IN">NOT IN</option>
</select></td>
<td class="even" nowrap="nowrap"><input type="text"  name="value_animid" size="50">&nbsp;&nbsp;(hint: BRIS, KUS, TMR)
</input>
</td></tr>
<tr>
<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_animname" /></td><td class="odd" nowrap="nowrap">Animal Name</td><td class="odd" nowrap="nowrap"><select name="op_animname">

<option value="=">=</option>
<option value="!=">!=</option>
<option value="LIKE">LIKE</option>
<option value="NOT LIKE">NOT LIKE</option>
<option value="ILIKE">ILIKE</option>
<option value="NOT ILIKE">NOT ILIKE</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
<option value="IN">IN</option>
<option value="NOT IN">NOT IN</option>
</select></td>
<td class="odd" nowrap="nowrap"><input type="text"  name="value_animname" size="50">&nbsp;&nbsp;(hint: Brisa, Nilo, Blaze)
</input>
</td></tr>
<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_birthgroup" /></td><td class="even" nowrap="nowrap">Birth Group</td><td class="even" nowrap="nowrap"><select name="op_birthgroup">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="LIKE">LIKE</option>
<option value="NOT LIKE">NOT LIKE</option>
<option value="ILIKE">ILIKE</option>
<option value="NOT ILIKE">NOT ILIKE</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
<option value="IN">IN</option>
<option value="NOT IN">NOT IN</option>
</select></td>
<td class="even" nowrap="nowrap"><input type="text"  name="value_birthgroup" size="50">&nbsp;&nbsp;(hint: Twn, Bwenge, Pablo)
</input>
</td></tr>
<tr>

<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_bgqual" /></td><td class="odd" nowrap="nowrap">Birth Group Certainty</td><td class="odd" nowrap="nowrap"><select name="op_bgqual">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select></td>
<td class="odd" nowrap="nowrap"><select name="value_bgqual">
<option value=""></option>      
<option value="C">Certain</option>
<option value="U">Uncertain</option>
</select>
</td></tr>
<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_sex" /></td><td class="even" nowrap="nowrap">sex</td><td class="even" nowrap="nowrap"><select name="op_sex">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select></td>

<td class="even" nowrap="nowrap"><select name="value_sex">
<option value=""></option>
<option value="M">Male</option>
<option value="F">Female</option>
<option value="U">Unknown</option>
</select>
</td></tr>
<tr>
<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_momid" /></td><td class="odd" nowrap="nowrap">Mom Id</td><td class="odd" nowrap="nowrap"><select name="op_momid">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="LIKE">LIKE</option>
<option value="NOT LIKE">NOT LIKE</option>
<option value="ILIKE">ILIKE</option>
<option value="NOT ILIKE">NOT ILIKE</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
<option value="IN">IN</option>
<option value="NOT IN">NOT IN</option>
</select></td>
<td class="odd" nowrap="nowrap"><input type="text"  name="value_momid" size="50">&nbsp;&nbsp;(hint: BRAH, HookF, Ambe)
</input>
</td></tr>
<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_firstborn" /></td><td class="even" nowrap="nowrap">Is First Born?</td><td class="even" nowrap="nowrap">
<select name="op_firstborn">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select>
</td>
<td class="even" nowrap="nowrap"><select name="value_firstborn">
<option value=""></option>
<option value="Y">Yes</option>
<option value="N">No</option>
<option value="U">Unknown</option>
</select>
</td></tr>
<tr>
<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_birthdate" /></td><td class="odd" nowrap="nowrap">Birth Date</td><td class="odd" nowrap="nowrap">
<select name="op_birthdate">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="&lt;">&lt;</option>
<option value="&gt;">&gt;</option>
<option value="&lt;=">&lt;=</option>
<option value="&gt;=">&gt;=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select>
<td class="odd" nowrap="nowrap"><input name="value_birthdate" value="" size="12"  />(dd-Mon-YYYY)
</td></tr>

<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_bdmin" /></td><td class="even" nowrap="nowrap">Min Birth Date</td><td class="even" nowrap="nowrap">
<select name="op_bdmin">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="&lt;">&lt;</option>
<option value="&gt;">&gt;</option>
<option value="&lt;=">&lt;=</option>
<option value="&gt;=">&gt;=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select>
<td class="odd" nowrap="nowrap"><input name="value_bdmin" value="" size="12"  />(dd-Mon-YYYY)
</td></tr>

<tr>
<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_bdmax" /></td><td class="odd" nowrap="nowrap">Max Birth Date</td><td class="odd" nowrap="nowrap">
<select name="op_bdmax">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="&lt;">&lt;</option>
<option value="&gt;">&gt;</option>
<option value="&lt;=">&lt;=</option>
<option value="&gt;=">&gt;=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select>
<td class="odd" nowrap="nowrap"><input name="value_bdmax" value="" size="12"  />(dd-Mon-YYYY)
</td></tr>

<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_bddist" /></td><td class="even" nowrap="nowrap">Birth Date Distribution</td><td class="even" nowrap="nowrap"><select name="op_bddist">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="IN">IN</option>
<option value="NOT IN">NOT IN</option>
</select>
<td class="odd" nowrap="nowrap"><select name="value_bddist">
<option value=""></option>
<option value="U">uniform distributio</option>
<option value="N">normal distribution</option>
</select>
</td></tr>



<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_entrydate" /></td><td class="odd" nowrap="nowrap">Entry Date</td><td class="odd" nowrap="nowrap"><select name="op_entrydate">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="&lt;">&lt;</option>
<option value="&gt;">&gt;</option>
<option value="&lt;=">&lt;=</option>
<option value="&gt;=">&gt;=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select></td>
<td class="odd" nowrap="nowrap"><input name="value_entrydate" value="" size="12"  />(dd-Mon-YYYY)
</td></tr>
<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_entrytype" /></td><td class="even" nowrap="nowrap">Entry Type</td><td class="even" nowrap="nowrap"><select name="op_entrytype">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
<option value="IN">IN</option>
<option value="NOT IN">NOT IN</option>
</select></td>
<td class="even" nowrap="nowrap"><select name="value_entrytype">
<option value=""></option>
<option value="O">beginning of observation</option>
<option value="B">birth</option>
<option value="C">confirmed identification</option>
<option value="I">immigration into population</option>
</select>
</td></tr>
<tr>
<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_departdate" /></td><td class="odd" nowrap="nowrap">Depart Date</td><td class="odd" nowrap="nowrap"><select name="op_departdate">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="&lt;">&lt;</option>
<option value="&gt;">&gt;</option>
<option value="&lt;=">&lt;=</option>
<option value="&gt;=">&gt;=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select></td>
<td class="odd" nowrap="nowrap"><input name="value_departdate" value="" size="12"  />(dd-Mon-YYYY)
</td></tr>
<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_departdateerror" /></td><td class="even" nowrap="nowrap">Depart Date Error</td><td class="even" nowrap="nowrap">
<select name="op_departdateerror">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="&lt;">&lt;</option>
<option value="&gt;">&gt;</option>
<option value="&lt;=">&lt;=</option>
<option value="&gt;=">&gt;=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select></td>
<td class="even" nowrap="nowrap"><input name="value_departdateerror" value="" size="50"  />
</td></tr>
<tr>
<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_departtype" /></td><td class="odd" nowrap="nowrap">Depart Type</td><td class="odd" nowrap="nowrap"><select name="op_departtype">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="IN">IN</option>
<option value="NOT IN">NOT IN</option>
</select>
<td class="odd" nowrap="nowrap"><select name="value_departtype">
<option value=""></option>
<option value="D">death</option>
<option value="E">emigration from population</option>
<option value="O">end of observation</option>
<option value="P">permanent disappearance</option>
</select>
</td></tr>
<tr><td colspan="5"><input type="checkbox" checked="true"  id="selectall" name="selectall" onClick="javascript:selectAll()" /><label for="selectall">Select all fields</label></td></table></p>
<input type="submit" name="search" value="Search" />
<input type="reset" name="reset" value="Clear" /></p>
</form>
<p>All records will be returned if no searching conditions are specified.</p>
<div style="clear:both;"></div>

<%
java.util.Calendar calendar = java.util.Calendar.getInstance();
request.setAttribute("current_year", Integer.valueOf(calendar.get(java.util.Calendar.YEAR)));
request.setAttribute("current_month", Integer.valueOf(calendar.get(java.util.Calendar.MONTH)));
%>

<h3>Available downloads</h3>
<c:forEach var="year" begin="2010" end="${current_year}">
<ul>
<c:if test="${current_month<12 && year<current_year}">
<li><a href="download.go?f=biography_<c:out value='${year}' />_12_31.csv">12/31/<c:out value="${year}" /></a>
</li></c:if>
<c:if test="${current_month>7 && year>2010}">
<li><a href="download.go?f=biography_<c:out value='${year}' />_7_31.csv">7/31/<c:out value="${year}" /></a>
</li></c:if>
</ul>
</c:forEach>

<hr/>
<img src="/images/photos/BMSR-Sifaka-F80-2001-5wks-infantBrockmanCredit-small.jpg" style="float:right;margin-left: 15px; margin-bottom:15px;" />
<h3>Column Definition for Biography Downloads</h3>
<ul>
<li>Study/Species: the ID of the study. Because animals in a study are
  from a single species, the study also identifies the species. </li>
<li>AnimID:  the ID of each animal (typically an abbreviated code),
  which unambiguously identifies individuals within a study. Animals in different studies might have the same ID. </li>
<li>BirthGroup and BGQual: the social group into which an animal was
  born (BirthGroup) and the researcher's confidence ((U)ncertain,
  (C)ertain, or missing) in this assignment (BGQual). </li>
<li>Sex: sex of each individual, possible values include (M)ale,
  (F)emale, and (U)nknown</li>
<li>MomID:  the AnimID of an individual's mother.</li>
<li>FirstBorn:  whether individuals were known to be their mother's first offspring.</li>
<li>Birthdate, BDMin, BDMax:  Birth date, and estimates of the minimum (BDMin)
  and maximum (BDMax) possible dates in which the birth could have occurred..</li>
<li>BDDist: distribution of birth date estimates to increase precision. More information can be found in the methid paper.
   <ul><li>N: Normal. the most likely birthdate to be closer to Birthdate than to BDMin or BDMax</li>
   <li>U: Uniform. any birthdate between BDMin and BDMax (including Birthdate) was equally likely.</li>
   </ul>
<li>Entrydate and Entrytype:  the date and type at which individuals entered their respective study populations. Possible Entrytypes include:
	<ul><li>B: birth</li>
	<li>I: immigration</li>
	<li>C: start of confirmed identification of the individual</li>
	<li>O: initiation of close observation</li>
	</ul>
</li>
<li>Departdate and DepartdateError:  the last date on which an animal was observed in the study population is the Departdate. DepartdateError reflects the time between Departdate 
(last date observed) and the first time that an animal was confirmed
  missing (e.g., when observations resumed and all individuals present
  could be expected to be re-encountered), and is expressed as a
  fraction of a year (number of days divided by number of days in a
  year). It is greater than 0 whenever the number of days between Departdate and retrospective 
confirmed missing date was more than 15 days. In some studies, members
  of the study population did not live in cohesive groups, making it
  difficult to specify an expected lag to re-sighting and a corresponding DepartdateError.  In cases when DepartdateError cannot be calculated, its value is missing.
</li>
<li>DepartType:  the type of departure of an individual from the population, including: 
	<ul><li>D: death</li>
	<li>E: emigration</li>
	<li>P: permanent disappearance</li>
	<li>O: the end of observation, which means that the individual was still present at the most recent census date. </li>
	</ul>
</li>
</ul>
