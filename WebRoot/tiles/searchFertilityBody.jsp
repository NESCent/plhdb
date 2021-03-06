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
</script>
<h2>Search Fertility Interval</h2>
<form action="/search/fertility.go" method="post" name="selectform">
<table>
<tr><td colspan="5"><input type="checkbox" id="searchDistribution" name="searchDistribution" onClick="javascript:searchDistributionClicked()" /><label for="searchDistribution">Search Distribution</label><br/>
Check 'Search Distribution' to get a summary result of data records distribution according to the fields you choose below. For example, you can get a distribution of start type by ckecking the start type field. The distribution 
search can also be combined with filtering conditions, such as start type distribution for all animals from study 1.</td>
<tr><tr><th id="thShow" name="thShow">Show</th><th>Column</th><th>Operator</th><th>Value</th></tr><tr>
<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_studyid" /></td>
<td class="odd" nowrap="nowrap">Study/Species</td><td class="odd" nowrap="nowrap">
<select name="op_studyid">
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
<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_startdate" /></td><td class="odd" nowrap="nowrap">Start Date</td><td class="odd" nowrap="nowrap">
<select name="op_startdate">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="&lt;">&lt;</option>
<option value="&gt;">&gt;</option>
<option value="&lt;=">&lt;=</option>
<option value="&gt;=">&gt;=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select>
<td class="odd" nowrap="nowrap"><input name="value_startdate" value="" size="12"  />(dd-Mon-YYYY)
</td></tr>
<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_starttype" /></td><td class="even" nowrap="nowrap">Start Type</td>
<td class="even" nowrap="nowrap"><select name="op_starttype">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
<option value="IN">IN</option>
<option value="NOT IN">NOT IN</option>
</select></td>
<td class="even" nowrap="nowrap"><select name="value_starttype">
<option value=""></option>
<option value="O">beginning of observation</option>
<option value="B">birth</option>
<option value="C">confirmed identification</option>
<option value="I">immigration into population</option>
</select>
</td></tr>

<tr>
<td class="odd" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_stopdate" /></td><td class="odd" nowrap="nowrap">Stop Date</td><td class="odd" nowrap="nowrap">
<select name="op_stopdate">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="&lt;">&lt;</option>
<option value="&gt;">&gt;</option>
<option value="&lt;=">&lt;=</option>
<option value="&gt;=">&gt;=</option>
<option value="IS NULL">IS NULL</option>
<option value="IS NOT NULL">IS NOT NULL</option>
</select>
<td class="odd" nowrap="nowrap"><input name="value_stopdate" value="" size="12"  />(dd-Mon-YYYY)
</td></tr>

<tr>
<td class="even" nowrap="nowrap"><input type="checkbox" checked="true"  name="show_stoptype" /></td><td class="odd" nowrap="nowrap">Stop Type</td>
<td class="even" nowrap="nowrap"><select name="op_stoptype">
<option value="=">=</option>
<option value="!=">!=</option>
<option value="IN">IN</option>
<option value="NOT IN">NOT IN</option>
</select>
<td class="even" nowrap="nowrap"><select name="value_stoptype">
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
<%--<c:forEach var="year" begin="2010" end="${current_year}">
<ul>
<c:if test="${current_month<12 && year<current_year}">
<li><a href="download.go?f=fertility_<c:out value='${year}' />_12_31.csv">12/31/<c:out value="${year}" /></a>
</li></c:if>
<c:if test="${current_month>7 && year>2010}">
<li><a href="download.go?f=fertility_<c:out value='${year}' />_7_31.csv">7/31/<c:out value="${year}" /></a>
</li></c:if>
</ul>

</c:forEach>--%>

<hr/>
<img src="/images/photos/Campos-Fedigan-Cebus-capucinus-small.jpg" style="float:right;margin-left: 15px; margin-bottom:15px;" />

<h3>Column Definitions for Female Fertility Record Downloads</h3>
<ul>
<li>Study/Species: the ID of the study. Because animals in a study are from a single species, the study also identifies the species.</li>
<li>AnimID:  the ID of each animal (typically an abbreviated code),
  which unambiguously identifies individuals within a study. Animals in different studies might have the same ID. </li>
<li>Startdate and Stopdate: the start end end dates of an uninterrupted period of observation on a female during which no possible births would have been missed.</li>
<li>Starttype and Stoptype: see Entrytype and Departype in BIOGRAPHY; these correspond to Starttype and Stoptype in FERTILITY.</li>
</ul>
