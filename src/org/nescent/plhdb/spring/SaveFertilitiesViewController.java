package org.nescent.plhdb.spring;

import java.security.AccessControlException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import org.nescent.plhdb.hibernate.dao.Femalefertilityinterval;
import org.nescent.plhdb.hibernate.dao.Individual;
import org.nescent.plhdb.util.Fertility;
import org.nescent.plhdb.util.PrepareModel;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class SaveFertilitiesViewController implements Controller {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(SaveFertilitiesViewController.class);
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
			throw new IllegalArgumentException("No animal oid specified.");
		}
		Session session = null;
		Transaction tx = null;
		session = HibernateSessionFactory.getSession();
		tx = session.beginTransaction();
		String s = null;
		try {
			for (Fertility f : getFertilities(request)) {
				s = f.toString();
				saveFertilityView(individual_id, f, session);
			}

			session.flush();
			tx.commit();
		} catch (HibernateException he) {
			log().error("failed to save fertility: " + s, he);
			throw he;
		} finally {
			if (!tx.wasCommitted())
				tx.rollback();
		}

		Map<String, Object> models = PrepareModel.prepare(null, individual_id,
				manager);
		models.put("tab", "fertility");
		return new ModelAndView("editData", models);

	}

	public boolean isValid(String str) {
		return (str != null && !str.trim().equals(""));
	}

	@SuppressWarnings("unchecked")
	public void saveFertilityView(String individual_id, Fertility fertility,
			Session session) {
		
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

		SimpleDateFormat sdm = new SimpleDateFormat("dd-MMM-yyyy");

		if (fertility_id.equals("-1")) { // new record
			if (!isValid(startdate) || !isValid(starttype)) {
				throw new IllegalArgumentException(
						"No start date or start type specified.");
			}

			Femalefertilityinterval period = new Femalefertilityinterval();
			period.setAnimOid(Integer.parseInt(individual_id));
			Individual indv = (Individual) session.get(
					"org.nescent.plhdb.hibernate.dao.Individual", Integer
							.parseInt(individual_id));

			if (indv == null) {
				throw new IllegalArgumentException(
						"failed to retrieve the individual with oid: "
								+ individual_id);
			}
			period.setStudyid(indv.getStudy().getStudyId());
			period.setAnimid(indv.getIndividualId());

			java.sql.Date date = null;
			try {
				java.util.Date ud = sdm.parse(startdate);
				date = new java.sql.Date(ud.getTime());
			} catch (ParseException e) {
				throw new IllegalArgumentException("invalid date: " + startdate);
			}
			period.setStartdate(date);
			period.setStarttype(starttype);

			if (isValid(stopdate) && isValid(stoptype)) {
				date = null;
				try {
					java.util.Date ud = sdm.parse(stopdate);
					date = new java.sql.Date(ud.getTime());
				} catch (ParseException e) {
					throw new IllegalArgumentException("invalid date: "
							+ stopdate);
				}
				period.setStopdate(date);
				period.setStoptype(stoptype);
			} else {
				period.setStopdate(null);
				period.setStoptype(null);
			}
			session.save(period);
		} else { // existing fertility
			Femalefertilityinterval period = (Femalefertilityinterval) session
					.get(Femalefertilityinterval.class, Integer
							.valueOf(fertility.getId()));
			if (!isValid(startdate) || !isValid(starttype)) {
				throw new IllegalArgumentException(
						"No start date or start type specified.");
			}

			Date date = null;
			try {
				java.util.Date ud = sdm.parse(startdate);
				date = new java.sql.Date(ud.getTime());
			} catch (ParseException e) {
				throw new IllegalArgumentException("invalid date: " + startdate);
			}
			period.setStartdate(date);
			period.setStarttype(starttype);

			if (isValid(stopdate) && isValid(stoptype)) {
				date = null;
				try {
					java.util.Date ud = sdm.parse(stopdate);
					date = new java.sql.Date(ud.getTime());
				} catch (ParseException e) {
					throw new IllegalArgumentException("invalid date: "
							+ stopdate);
				}
				period.setStopdate(date);
				period.setStoptype(stoptype);
			} else {
				period.setStopdate(null);
				period.setStoptype(null);
			}
			session.update(period);
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
