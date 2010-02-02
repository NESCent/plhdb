package org.nescent.plhdb.spring;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Cvterm;
import org.nescent.plhdb.hibernate.dao.Individual;
import org.nescent.plhdb.hibernate.dao.Observation;
import org.nescent.plhdb.hibernate.dao.Recordingperiod;
import org.nescent.plhdb.util.CvtermDAO;
import org.nescent.plhdb.util.Fertility;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;
import java.security.AccessControlException;

public class SaveFertilitiesController implements Controller {
    private static Logger log;

    private static Logger log() {
	if (log == null) {
	    log = Logger.getLogger(SaveFertilitiesController.class);
	}
	return log;
    }

    public ModelAndView handleRequest(HttpServletRequest request,
	    HttpServletResponse response) {
	PermissionManager manager = (PermissionManager) request.getSession()
		.getAttribute("permission_manager");
	if (manager == null) {
	    throw new AccessControlException("You have not logged in.");
	}
	String individual_id = request.getParameter("individual_id");

	if (!isValid(individual_id)) {
	    throw new IllegalArgumentException("No animal id specified.");
	}
	Session session = HibernateSessionFactory.getSession();

	Individual currentIndividual = (Individual) session.get(
		"org.nescent.plhdb.hibernate.dao.Individual", Integer
			.parseInt(individual_id));
	if (currentIndividual == null) {
	    throw new IllegalArgumentException("No individual found with id: "
		    + individual_id);
	}

	for (Fertility f : getFertilities(request)) {
	    saveFertility(currentIndividual, f);
	}

	Map<String, Object> models = PrepareModel.prepare(null,
		currentIndividual.getIndividualId(), manager);
	models.put("tab", "fertility");
	return new ModelAndView("editData", models);

    }

    public boolean isValid(String str) {
	return (str != null && !str.trim().equals(""));
    }

    @SuppressWarnings("unchecked")
    public void saveFertility(Individual individual, Fertility fertility) {
	String fertility_id = fertility.getId();
	String startdate = fertility.getStartDate();
	String stopdate = fertility.getStopDate();
	String starttype = fertility.getStartType();
	String stoptype = fertility.getStopType();

	if ((isValid(startdate) && !isValid(starttype))
		|| (!isValid(startdate) && isValid(starttype))) {
	    throw new IllegalArgumentException(
		    "No start date or start type specified.");
	}

	if ((isValid(stopdate) && !isValid(stoptype))
		|| (!isValid(stopdate) && isValid(stoptype))) {
	    throw new IllegalArgumentException(
		    "No stop date or stop type specified.");
	}

	Recordingperiod period = null;
	Observation startObs = null;
	Observation endObs = null;

	SimpleDateFormat sfm = new SimpleDateFormat("dd-MMM-yyyy");
	Session session = HibernateSessionFactory.getSession();
	Transaction tx = session.beginTransaction();

	try {
	    Cvterm starttype_term = CvtermDAO.getCvterm(starttype,
		    "event types");
	    Cvterm stoptype_term = CvtermDAO.getCvterm(stoptype, "event types");
	    Cvterm period_term = CvtermDAO.getCvterm("female fertility period",
		    "period types");

	    if (fertility_id.equals("-1")) { // new record

		if (isValid(startdate) && isValid(starttype)) {
		    period = new Recordingperiod();
		    period.setCvterm(period_term);
		    period_term.getRecordingperiods().add(period);
		    startObs = new Observation();
		    startObs.setIndividual(individual);
		    individual.getObservations().add(startObs);
		    try {
			Date date = sfm.parse(startdate);
			startObs.setTimeOfObservation(date);
		    } catch (ParseException ex) {
			throw new IllegalArgumentException(
				"failed to parse the start date" + startdate,
				ex);
		    }

		    startObs.setCvterm(starttype_term);
		    starttype_term.getObservations().add(startObs);
		    period.setObservationByStartOid(startObs);
		    startObs.getRecordingperiodsForStartOid().add(period);
		} else {
		    throw new IllegalArgumentException(
			    "No start date or start type specified.");
		}

		if (isValid(stopdate) && isValid(stoptype)) {
		    endObs = new Observation();
		    endObs.setIndividual(individual);
		    individual.getObservations().add(endObs);
		    try {
			Date date = sfm.parse(stopdate);
			endObs.setTimeOfObservation(date);
		    } catch (ParseException ex) {
			throw new IllegalArgumentException(
				"failed to parse the stop date: " + stopdate,
				ex);
		    }
		    endObs.setCvterm(stoptype_term);
		    stoptype_term.getObservations().add(endObs);
		    period.setObservationByEndOid(endObs);
		    endObs.getRecordingperiodsForEndOid().add(period);
		}

	    } else { // existing recordingperiod
		period = (Recordingperiod) session.get(
			"org.nescent.plhdb.hibernate.dao.Recordingperiod",
			Integer.parseInt(fertility_id));
		if (period == null) {
		    log().error(
			    "failed to find the fermale fertility recordingperiod with id: "
				    + fertility_id);
		    throw new IllegalArgumentException(
			    "failed to find the fermale fertility recordingperiod with id: "
				    + fertility_id);
		}

		startObs = period.getObservationByStartOid();
		endObs = period.getObservationByEndOid();

		if (isValid(startdate) && isValid(starttype)) {
		    try {
			Date date = sfm.parse(startdate);
			startObs.setTimeOfObservation(date);
		    } catch (ParseException ex) {
			throw new IllegalArgumentException(
				"failed to parse the start date" + startdate,
				ex);
		    }

		    startObs.setCvterm(starttype_term);
		    starttype_term.getObservations().add(startObs);

		} else {
		    throw new IllegalArgumentException(
			    "No start date or start type specified.");
		}

		if (isValid(stopdate) && isValid(stoptype)) {
		    if (endObs == null) {
			endObs = new Observation();
			endObs.setIndividual(individual);
			individual.getObservations().add(endObs);
			period.setObservationByEndOid(endObs);
			endObs.getRecordingperiodsForEndOid().add(period);
		    }
		    try {
			Date date = sfm.parse(stopdate);
			endObs.setTimeOfObservation(date);
		    } catch (ParseException ex) {
			throw new IllegalArgumentException(
				"failed to parse the stop date: " + stopdate,
				ex);
		    }
		    endObs.setCvterm(stoptype_term);
		    stoptype_term.getObservations().add(endObs);

		} else {
		    if (endObs != null) {
			session.delete(endObs);
			period.setObservationByEndOid(null);
		    }
		}
	    }

	    session.update(individual);
	    session.flush();
	    tx.commit();

	} catch (HibernateException he) {
	    log().error("failed to save fertility.", he);
	    throw he;
	} finally {
	    if (!tx.wasCommitted())
		tx.rollback();
	}
    }

    @SuppressWarnings("unchecked")
    public List<Fertility> getFertilities(HttpServletRequest request) {
	List<Fertility> list = new ArrayList<Fertility>();
	for (Enumeration en = request.getParameterNames(); en.hasMoreElements();) {
	    String name = (String) en.nextElement();

	    if (name.indexOf("newid") != -1) {
		Fertility f = new Fertility();
		f.setId("-1");
		String id = request.getParameter(name);
		f.setStartDate(nullIfEmpty(request.getParameter("newstartdate"
			+ id)));
		f.setStartType(nullIfEmpty(request.getParameter("newstarttype"
			+ id)));
		f.setStopDate(nullIfEmpty(request.getParameter("newstopdate"
			+ id)));
		f.setStopType(nullIfEmpty(request.getParameter("newstoptype"
			+ id)));
		list.add(f);
	    } else if (name.indexOf("id") == 0) {
		Fertility f = new Fertility();
		String id = nullIfEmpty(request.getParameter(name));
		f.setId(id);
		f.setStartDate(nullIfEmpty(request.getParameter("startdate"
			+ id)));
		f.setStartType(nullIfEmpty(request.getParameter("starttype"
			+ id)));
		f
			.setStopDate(nullIfEmpty(request
				.getParameter("stopdate" + id)));
		f
			.setStopType(nullIfEmpty(request
				.getParameter("stoptype" + id)));
		list.add(f);
	    }
	}

	return list;
    }

    private String nullIfEmpty(String s) {
	return (s != null && s.trim().equals("")) ? null : s;
    }
}
