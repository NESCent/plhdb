<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>   
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/fmt.tld"%>
<%@ page import="org.nescent.plhdb.util.NoCache" %>


<%
     
NoCache.nocache(response);
boolean loggedIn=(request.getSession().getAttribute("permission_manager")!=null);


%>
<h2>Introduction</h2>
<img src="/images/photos/Muriqui-Bandit-Kali-CBP.jpg" width="194" height="301" style="float: right; margin-left: 15px; margin-bottom: 15px;">
<img src="/images/photos/VECELLIO-small.jpg" width="310" height="228" style="float:left; margin-right: 15px; margin-bottom: 15px;">
<p>Primates are highly charismatic and often serve as flagship species in conservation efforts. They are also the closest living relatives of humans, and therefore 
hold the keys to resolving many questions about human evolution and ecology. However, the slow life histories of primates, combined with their complex social systems, 
their behavioral plasticity, and the challenging field conditions in which primate researchers must work, have limited comparative analyses of primate mortality and 
fertility in wild, unprovisioned populations. This in turn limits our understanding of population dynamics and of the social and ecological adaptations that have 
shaped both human and nonhuman primate evolution.
</p>
<p>
The Primate Life History Database (PLHD) was designed to permit comparative analyses of the evolution of primate life histories. It contains individual-based life history data 
from wild primate populations that have been collected by eight working group participants/organizations over a minimum of 24 years. Records in the database include mortality and fertility 
schedules for seven primate taxa. The data are searchable and can be downloaded into csv format, but access to the complete PLHD is currently limited to Working Group members.
</p>
<p>
This Demo site was created to illustrate how the actual online database works. It was produced by <a href="http://www.nescent.org/science/awards_summary.php?id=19">the Evolutionary Ecology of Primate Life Histories Working Group</a>
through the <a href="http://www.nescent.org">National Evolutionary Synthesis Center</a>. It includes an example dataset, taken from the actual database, to illustrate the graphical 
user interface.
</p>
<h3>How To Cite This Database</h3>
<p>Please cite the following paper:</p>
<p>Karen B. Strier, Jeanne Altmann, Diane K. Brockman, Anne
  M. Bronikowski, Marina Cords, Linda M. Fedigan, Hilmar Lapp, Xianhua
  Liu, William F. Morris, Anne E. Pusey, Tara S. Stoinski and Susan
  C. Alberts. 2010. <a href="http://dx.doi.org/10.1111/j.2041-210X.2010.00023.x"
  target="_blank">The Primate Life History Database: a unique shared ecological data resource.</a> Methods in Ecology and Evolution 1(2): 199-211.
</p>

<h3>How to access the demo database</h3>
<img src="/images/photos/Fundi_Fanni_Familia_Fadhila_3_A_small.jpg" width="273" height="209" style="float: right;margin-left: 15px; margin-bottom: 15px;">
<p>
Anybody can use this web interface to search or download Demo data from this subset of examples from the PLHD. However the sample data provided here should not be 
considered to be representative of the life histories of any of the species or populations included in the PLHD. We do not authorize the use of this small sample 
for actual analyses of primate life histories; they will be incomplete and any results may be potentially misleading with respect to actual life histories.
</p>
<h3>Documents</h3>
<ul>
<li><a href="/MOU">Memorandum of Understanding among the PLHD Working Group Members</a>.</li>
<li><a href="/Acknowledgments">Acknowledgments</a>.</li>
</ul>
<h3>Related web resources</h3>
<ul>
<li><a href="https://www.nescent.org/wg_plhd">Project wiki site of the working group</a></li>
<li><a href="http://www.nescent.org/science/awards_summary.php?id=19">NESCent award page of the working group</a></li>
<li>Source code <a href="http://github.com/NESCent/plhdb">on GitHub</a></li>
<li><a href="http://www.nescent.org">National Evolutionary Synthesis Center</a> (NESCent)</li>
</ul>
