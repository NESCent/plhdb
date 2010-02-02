package org.nescent.plhdb.spring;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.nescent.plhdb.aa.Permission;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.util.SearchFertilityForm;
import org.nescent.plhdb.util.StringUtils;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import java.security.AccessControlException;

public class SearchFertilityController extends SimpleFormController {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(SearchFertilityController.class);
		}
		return log;
	}

	@SuppressWarnings("unchecked")
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors) {

		SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");

		SearchFertilityForm form = (SearchFertilityForm) command;

		List<String> showFieldNames = new ArrayList<String>();
		List<String> showFields = new ArrayList<String>();

		if (form.getShow_studyid() != null) {
			showFields.add("Study Id");
			showFieldNames.add("studyid");
		}

		if (form.getShow_animid() != null) {
			showFields.add("Animal Id");
			showFieldNames.add("animid");
		}

		if (form.getShow_startdate() != null) {
			showFields.add("Start Date");
			showFieldNames.add("startdate");
		}
		if (form.getShow_starttype() != null) {
			showFields.add("Start Type");
			showFieldNames.add("starttype");
		}
		if (form.getShow_stopdate() != null) {
			showFields.add("Stop Date");
			showFieldNames.add("stopdate");
		}
		if (form.getShow_stoptype() != null) {
			showFields.add("Stop Type");
			showFieldNames.add("stoptype");
		}

		if (form.getSearchDistribution() != null) {
			showFields.add("Count");
			showFieldNames.add("count(*)");
		}

		Map<String, Object> searchParams = new HashMap<String, Object>();
		List<String> searchConds = new ArrayList<String>();

		String sql = "";
		String groupby = "";

		for (int i = 0; i < showFields.size(); i++) {
			sql += showFieldNames.get(i);

			if (i < showFields.size() - 1) {
				sql += ",";
				groupby += showFieldNames.get(i);
				if (i < showFields.size() - 2) {
					groupby += ",";
				}
			}
		}

		if (form.getOp_animid().indexOf("NULL") != -1) {
			searchConds.add("animid " + form.getOp_animid());
		} else if (form.getValue_animid() != null) {
			searchConds.add("animid " + form.getOp_animid() + " :animid");
			if (form.getOp_animid().indexOf("LIKE") != -1) {
				if (!form.getValue_animid().startsWith("%")
						&& !form.getValue_animid().endsWith("%")) {
					searchParams.put("animid", "%" + form.getValue_animid()
							+ "%");
				} else {
					searchParams.put("animid", form.getValue_animid());
				}
			} else {
				searchParams.put("animid", form.getValue_animid());
			}
		}

		if (form.getOp_startdate().indexOf("NULL") != -1) {
			searchConds.add("startdate " + form.getOp_startdate());
		} else if (form.getValue_startdate() != null) {
			searchConds.add("startdate " + form.getOp_startdate()
					+ " :startdate");
			try {
				searchParams.put("startdate", sdf.parse(form
						.getValue_startdate()));
			} catch (ParseException pe) {
				log().error(
						"failed to parse the date string: "
								+ form.getValue_startdate(), pe);
				throw new IllegalArgumentException(
						"failed to parse the date string: "
								+ form.getValue_startdate(), pe);
			}
		}
		if (form.getOp_stopdate().indexOf("NULL") != -1) {
			searchConds.add("stopdate " + form.getOp_stopdate());
		} else if (form.getValue_stopdate() != null) {
			searchConds.add("stopdate " + form.getOp_stopdate() + " :stopdate");
			try {
				searchParams.put("stopdate", sdf
						.parse(form.getValue_stopdate()));
			} catch (ParseException pe) {
				log().error(
						"failed to parse the date string: "
								+ form.getValue_stopdate(), pe);
				throw new IllegalArgumentException(
						"failed to parse the date string: "
								+ form.getValue_stopdate(), pe);
			}
		}

		if (form.getOp_starttype().indexOf("NULL") != -1) {
			searchConds.add("starttype " + form.getOp_starttype());
		} else if (form.getValue_starttype() != null) {
			searchConds.add("starttype " + form.getOp_starttype()
					+ " :starttype");
			if (form.getOp_starttype().indexOf("LIKE") != -1) {
				if (!form.getValue_starttype().startsWith("%")
						&& !form.getValue_starttype().endsWith("%")) {
					searchParams.put("starttype", "%"
							+ form.getValue_starttype() + "%");
				} else {
					searchParams.put("starttype", form.getValue_starttype());
				}
			} else {
				searchParams.put("starttype", form.getValue_starttype());
			}
		}

		if (form.getOp_stoptype().indexOf("NULL") != -1) {
			searchConds.add("stoptype " + form.getOp_stoptype());
		} else if (form.getValue_stoptype() != null) {
			searchConds.add("stoptype " + form.getOp_stoptype() + " :stoptype");
			if (form.getOp_stoptype().indexOf("LIKE") != -1) {
				if (!form.getValue_stoptype().startsWith("%")
						&& !form.getValue_stoptype().endsWith("%")) {
					searchParams.put("stoptype", "%" + form.getValue_stoptype()
							+ "%");
				} else {
					searchParams.put("stoptype", form.getValue_stoptype());
				}
			} else {
				searchParams.put("stoptype", form.getValue_stoptype());
			}
		}

		if (form.getOp_studyid().indexOf("NULL") != -1) {
			searchConds.add("studyid " + form.getOp_studyid());
		} else if (form.getValue_studyid() != null) {
			searchConds.add("studyid " + form.getOp_studyid() + " :studyid");
			if (form.getOp_studyid().indexOf("LIKE") != -1) {
				if (!form.getValue_studyid().startsWith("%")
						&& !form.getValue_studyid().endsWith("%")) {
					searchParams.put("studyid", "%" + form.getValue_studyid()
							+ "%");
				} else {
					searchParams.put("studyid", form.getValue_studyid());
				}
			} else {
				searchParams.put("studyid", form.getValue_studyid());
			}
		}

		
		if (searchConds.size() > 0) {
			sql = "select " + sql + " FROM Femalefertilityinterval WHERE "
					+ StringUtils.join(searchConds, " AND ");

		} else {
			sql = "select " + sql + " FROM Femalefertilityinterval ";
		}

		if (form.getSearchDistribution() != null && !groupby.equals("")) {
			sql += " GROUP BY " + groupby;
		}

		if (form.getSortBy() != null) {
			sql += " ORDER BY " + form.getSortBy();
			if (form.getOrder() != null)
				sql += " " + form.getOrder();
		}else{
			if (form.getSearchDistribution() == null || groupby.equals("")) {
				sql += " ORDER BY studyid, animid, startdate";
			}
			
		}

		Session session = HibernateSessionFactory.getSession();
		Transaction tx = session.beginTransaction();
		try {
			Query q = session.createQuery(sql);

			for (String searchParam : searchParams.keySet()) {
				Object param = searchParams.get(searchParam);
				if (param instanceof Date) {
					q.setDate(searchParam, (Date) param);
				} else if (param instanceof Integer) {
					q.setInteger(searchParam, (Integer) param);
				} else if (param instanceof Double) {
					q.setDouble(searchParam, (Double) param);
				} else if (param instanceof Character) {
					q.setCharacter(searchParam, (Character) param);
				} else {
					q.setString(searchParam, param.toString());
				}
			}
			int page = 0;
			if (form.getPage() != null)
				page = Integer.parseInt(form.getPage());
			else
				form.setPage("0");

			int num_per_page = 50;
			if (form.getNumPerPage() != null)
				num_per_page = Integer.parseInt(form.getNumPerPage());
			else
				form.setNumPerPage("50");

			Map models = new HashMap();
			int total = q.list().size();
			models.put("showFields", showFields);
			models.put("totalRecord", Integer.valueOf(total));
			models.put("searchForm", form);
			if (form.getDownload() != null && form.getDownload().equals("true")) {
				models.put("fertilities", q.list());
				return new ModelAndView("fertilityDownload", models);
			}

			q.setFirstResult(page * num_per_page);
			q.setMaxResults(num_per_page);

			models.put("fertilities", q.list());

			return new ModelAndView("fertilityList", models);
		} catch (HibernateException e) {
			log().error("failed to search biography", e);
			throw e;
		} finally {
			if (tx.isActive() && !tx.wasCommitted())
				tx.rollback();
		}
	}

	public String getStudyConstraints(PermissionManager manager) {

		List permittedstudies = manager
				.getPermittedStudies(Permission.ACCESS_TYPE_SEARCH);
		if (permittedstudies.size() == 0) {
			throw new AccessControlException(
					"You do not have the authority to search any studies.");
		}
		String where = "";
		for (int i = 0; i < permittedstudies.size(); i++) {
			String std = (String) permittedstudies.get(i);
			if (std.equals(Permission.ACCESS_TYPE_ALL)) {
				where = "";
				break;
			} else {
				if (!where.equals(""))
					where += " OR ";
				where += "studyid ='" + std + "'";
			}
		}

		return where;
	}

	public static void main(String[] agrs) {
		String sql = "FROM Biography ";
		Session session = HibernateSessionFactory.getSession();
		Query q = session.createQuery(sql);

		int total = q.list().size();
		q.setFirstResult(0);
		q.setMaxResults(2);
	}
}
