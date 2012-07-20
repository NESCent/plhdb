<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>   
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/fmt.tld"%>
<%@ page import="org.nescent.plhdb.util.NoCache" %>


<%
     
NoCache.nocache(response);
boolean loggedIn=(request.getSession().getAttribute("permission_manager")!=null);
%>
<div id="left">

<h2>Introduction</h2>
<p>Primates are highly charismatic and often serve as flagship species in conservation efforts. 
They are also the closest living relatives of humans, and therefore hold the keys to resolving many 
questions about human evolution and ecology. However, the slow life histories of primates, combined with 
their complex social systems, their behavioral plasticity, and the challenging field conditions in which 
primate researchers must work, have severely limited analyses of mortality and fertility in wild, unprovisioned 
primate populations. This in turn limits comparative analyses that can shed light on the population dynamics and 
the social and ecological adaptations that have shaped both human and nonhuman primate evolution. </p>
<p>This database contains  individual-based life 
history data that have been collected from wild primate populations by nine working group participants over a minimum of 19 years.  The purpose of collecting 
data of this type is to make comparative analyses that can shed light on the population dynamics and 
the social and ecological adaptations that have shaped both human and nonhuman primate evolution. Records in the database include mortality and fertility schedules across multiple primate taxa. The data are searchable and can be downloaded 
into  csv format.</p>
<p>This site was produced by <a href="http://www.nescent.org/science/awards_summary.php?id=19">the Evolutionary Ecology of Primate Life Histories Working Group</a> 
through the <a href="http://www.nescent.org">National Evolutionary Synthesis Center</a>. This site is currently only accessible for the working group members. If you want to see how the system work, please visit 
our <a href="http://demo.plhdb.org">demo site</a>, which includes an example dataset, representing a subset of the actual database, as well as a live version of the graphical user interface. </p>
<h3>How To Cite This Database</h3>
<p>Please cite the following paper:</p>
<p>Karen B. Strier, Jeanne Altmann, Diane K. Brockman, Anne
  M. Bronikowski, Marina Cords, Linda M. Fedigan, Hilmar Lapp, Xianhua
  Liu, William F. Morris, Anne E. Pusey, Tara S. Stoinski and Susan
  C. Alberts. 2010. <a href="http://dx.doi.org/10.1111/j.2041-210X.2010.00023.x"
  target="_blank">The Primate Life History Database: a unique shared ecological data resource.</a> Methods in Ecology and Evolution 1(2): 199–211.
</p>

<h3>Documents</h3>
<ul>
<li><a href="/MOU">Memorandum of Understanding among the PLHD Working Group Members</a>.</li>
<li><a href="/Acknowledgments">Acknowledgments</a>.</li>
</ul>
<h3>Related web resources</h3>
<ul>
<li><a href="http://demo.plhdb.org">Demo site</a></li>
<li><a href="https://www.nescent.org/wg_plhd">Project wiki site of the working group</a></li>
<li><a href="http://www.nescent.org/science/awards_summary.php?id=19">NESCent award page of the working group</a></li>
<li>Source code <a href="http://github.com/plhdb/plhdb">on GitHub</a> and <a href="http://sf.net/projects/plhdb">on SourceForge</a></li>
<li><a href="http://www.nescent.org">National Evolutionary Synthesis Center</a> (NESCent)</li>
</ul>
</div>

<div id="right">
<% if(loggedIn){ %>
<img src="/images/photos/Muriqui-Bandit-Kali-CBP.jpg" width="194" height="301" style=" margin-left: 15px; margin-bottom: 15px;"><br/>
<% } else { %>

<h2>Login</h2>

<form method="post" action="login.go">
    
    <table>

	    <tr>
	    	<td >Username</td>
	    	<td class="TdValue">

		    		<input type="text" name="email" value="" size="15"/>

			</td>
		</tr>
		<tr>
			<td >Password</td>
			<td class="TdValue">
    			
			    	<input type="password" name="password" value="" size="15"/>
		    	
			</td>

		</tr>
				
		<tr>
			<td></td>
			<td>
				<input type="submit" value="login" />
			</td>
		</tr>
		</table>
		
 
		<span>Forgot your username and password?<br/><a href="/jsp/resetpassword.jsp">Please retrieve it.</a></span> 

		
	</form>
	<% } %>
</div>
