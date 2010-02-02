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
import org.nescent.plhdb.util.SearchBiographyForm;
import org.nescent.plhdb.util.StringUtils;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import java.security.AccessControlException;

public class SearchBiographyController extends SimpleFormController {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(SearchBiographyController.class);
		}
		return log;
	}

	@SuppressWarnings("unchecked")
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors) {

		SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
		SearchBiographyForm form = (SearchBiographyForm) command;

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
		if (form.getShow_animname() != null) {
			showFields.add("Animal Name");
			showFieldNames.add("animname");
		}
		if (form.getShow_birthdate() != null) {
			showFields.add("Birth Date");
			showFieldNames.add("birthdate");
		}
		if (form.getShow_bdmin() != null) {
			showFields.add("Min Birth Date");
			showFieldNames.add("bdmin");
		}
		if (form.getShow_bdmax() != null) {
			showFields.add("Max Birth Date");
			showFieldNames.add("bdmax");
		}
		if (form.getShow_bddist() != null) {
			showFields.add("Birth Date Distribution");
			showFieldNames.add("bddist");
		}
		if (form.getShow_birthgroup() != null) {
			showFields.add("Birth Group");
			showFieldNames.add("birthgroup");
		}
		if (form.getShow_bgqual() != null) {
			showFields.add("Birth Group Certainty");
			showFieldNames.add("bgqual");
		}
		if (form.getShow_firstborn() != null) {
			showFields.add("First Born");
			showFieldNames.add("firstborn");
		}
		if (form.getShow_momid() != null) {
			showFields.add("Mom Id");
			showFieldNames.add("momid");
		}
		if (form.getShow_sex() != null) {
			showFields.add("Sex");
			showFieldNames.add("sex");
		}


		if (form.getShow_entrydate() != null) {
			showFields.add("Entry Date");
			showFieldNames.add("entrydate");
		}
		if (form.getShow_entrytype() != null) {
			showFields.add("Entry Type");
			showFieldNames.add("entrytype");
		}
		if (form.getShow_departdate() != null) {
			showFields.add("Depart Date");
			showFieldNames.add("departdate");
		}
		if (form.getShow_departtype() != null) {
			showFields.add("Depart Type");
			showFieldNames.add("departtype");
		}
		if (form.getShow_departdateerror() != null) {
			showFields.add("Depart Date Error");
			showFieldNames.add("departdateerror");
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

		if (form.getOp_animname().indexOf("NULL") != -1) {
			searchConds.add("animname " + form.getOp_animname());
		} else if (form.getValue_animname() != null) {
			searchConds.add("animname " + form.getOp_animname() + " :animname");
			if (form.getOp_animname().indexOf("LIKE") != -1) {
				if (!form.getValue_animname().startsWith("%")
						&& !form.getValue_animname().endsWith("%")) {
					searchParams.put("animname", "%" + form.getValue_animname()
							+ "%");
				} else {
					searchParams.put("animname", form.getValue_animname());
				}
			} else {
				searchParams.put("animname", form.getValue_animname());
			}
		}

		if (form.getOp_bdmin().indexOf("NULL") != -1) {
			searchConds.add("bdmin " + form.getOp_bdmin());
		} else if (form.getValue_bdmin() != null) {
			searchConds.add("bdmin " + form.getOp_bdmin()
					+ " :bdmin");
			try {
				searchParams.put("bdmin", sdf.parse(form
						.getValue_bdmin()));
			} catch (ParseException pe) {
				log().error(
						"failed to parse the date string: "
								+ form.getValue_bdmin(), pe);
				throw new IllegalArgumentException(
						"failed to parse the date string: "
								+ form.getValue_bdmin(), pe);
			}
		}
		
		if (form.getOp_bdmax().indexOf("NULL") != -1) {
			searchConds.add("bdmax " + form.getOp_bdmax());
		} else if (form.getValue_bdmax() != null) {
			searchConds.add("bdmax " + form.getOp_bdmax()
					+ " :bdmax");
			try {
				searchParams.put("bdmax", sdf.parse(form
						.getValue_bdmax()));
			} catch (ParseException pe) {
				log().error(
						"failed to parse the date string: "
								+ form.getValue_bdmax(), pe);
				throw new IllegalArgumentException(
						"failed to parse the date string: "
								+ form.getValue_bdmax(), pe);
			}
		}

		if (form.getOp_bddist().indexOf("NULL") != -1) {
			searchConds.add("bddist " + form.getOp_bddist());
		} else if (form.getValue_bddist() != null) {
			searchConds.add("bddist " + form.getOp_bddist()
					+ " :bddist");
			if (form.getOp_bddist().indexOf("LIKE") != -1) {
				if (!form.getValue_bddist().startsWith("%")
						&& !form.getValue_bddist().endsWith("%")) {
					searchParams.put("bddist", "%"
							+ form.getValue_bddist() + "%");
				} else {
					searchParams.put("bddist", form.getValue_bddist());
				}
			} else {
				searchParams.put("bddist", form.getValue_bddist());
			}
		}
		
		if (form.getOp_bgqual().indexOf("NULL") != -1) {
			searchConds.add("bgqual " + form.getOp_bgqual());
		} else if (form.getValue_bgqual() != null) {
			searchConds.add("bgqual " + form.getOp_bgqual() + " :bgqual");
			searchParams.put("bgqual", Character.valueOf(form.getValue_bgqual()
					.charAt(0)));
		}

		if (form.getOp_birthdate().indexOf("NULL") != -1) {
			searchConds.add("birthdate " + form.getOp_birthdate());
		} else if (form.getValue_birthdate() != null) {
			searchConds.add("birthdate " + form.getOp_birthdate()
					+ " :birthdate");
			try {
				searchParams.put("birthdate", sdf.parse(form
						.getValue_birthdate()));
			} catch (ParseException pe) {
				log().error(
						"failed to parse the date string: "
								+ form.getValue_birthdate(), pe);
				throw new IllegalArgumentException(
						"failed to parse the date string: "
								+ form.getValue_birthdate(), pe);
			}
		}
		if (form.getOp_birthgroup().indexOf("NULL") != -1) {
			searchConds.add("birthgroup " + form.getOp_birthgroup());
		} else if (form.getValue_birthgroup() != null) {
			searchConds.add("birthgroup " + form.getOp_birthgroup()
					+ " :birthgroup");
			if (form.getOp_birthgroup().indexOf("LIKE") != -1) {
				if (!form.getValue_birthgroup().startsWith("%")
						&& !form.getValue_birthgroup().endsWith("%")) {
					searchParams.put("birthgroup", "%"
							+ form.getValue_birthgroup() + "%");
				} else {
					searchParams.put("birthgroup", form.getValue_birthgroup());
				}
			} else {
				searchParams.put("birthgroup", form.getValue_birthgroup());
			}
		}
		if (form.getOp_entrydate().indexOf("NULL") != -1) {
			searchConds.add("entrydate " + form.getOp_entrydate());
		} else if (form.getValue_entrydate() != null) {
			searchConds.add("entrydate " + form.getOp_entrydate()
					+ " :entrydate");
			try {
				searchParams.put("entrydate", sdf.parse(form
						.getValue_entrydate()));
			} catch (ParseException pe) {
				log().error(
						"failed to parse the date string: "
								+ form.getValue_entrydate(), pe);
				throw new IllegalArgumentException(
						"failed to parse the date string: "
								+ form.getValue_entrydate(), pe);
			}
		}
		if (form.getOp_departdate().indexOf("NULL") != -1) {
			searchConds.add("departdate " + form.getOp_departdate());
		} else if (form.getValue_departdate() != null) {
			searchConds.add("departdate " + form.getOp_departdate()
					+ " :departdate");
			try {
				searchParams.put("departdate", sdf.parse(form
						.getValue_departdate()));
			} catch (ParseException pe) {
				log().error(
						"failed to parse the date string: "
								+ form.getValue_departdate(), pe);
				throw new IllegalArgumentException(
						"failed to parse the date string: "
								+ form.getValue_departdate(), pe);
			}
		}

		if (form.getOp_departdateerror().indexOf("NULL") != -1) {
			searchConds.add("departdateerror " + form.getOp_departdateerror());
		} else if (form.getValue_departdateerror() != null) {
			searchConds.add("departdateerror " + form.getOp_departdateerror()
					+ " :departdateerror");
			searchParams.put("departdateerror", Double.valueOf(form
					.getValue_departdateerror()));
		}

		if (form.getOp_entrytype().indexOf("NULL") != -1) {
			searchConds.add("entrytype " + form.getOp_entrytype());
		} else if (form.getValue_entrytype() != null) {
			searchConds.add("entrytype " + form.getOp_entrytype()
					+ " :entrytype");
			if (form.getOp_entrytype().indexOf("LIKE") != -1) {
				if (!form.getValue_entrytype().startsWith("%")
						&& !form.getValue_entrytype().endsWith("%")) {
					searchParams.put("entrytype", "%"
							+ form.getValue_entrytype() + "%");
				} else {
					searchParams.put("entrytype", form.getValue_entrytype());
				}
			} else {
				searchParams.put("entrytype", form.getValue_entrytype());
			}
		}

		if (form.getOp_departtype().indexOf("NULL") != -1) {
			searchConds.add("departtype " + form.getOp_departtype());
		} else if (form.getValue_departtype() != null) {
			searchConds.add("departtype " + form.getOp_departtype()
					+ " :departtype");
			if (form.getOp_departtype().indexOf("LIKE") != -1) {
				if (!form.getValue_departtype().startsWith("%")
						&& !form.getValue_departtype().endsWith("%")) {
					searchParams.put("departtype", "%"
							+ form.getValue_departtype() + "%");
				} else {
					searchParams.put("departtype", form.getValue_departtype());
				}
			} else {
				searchParams.put("departtype", form.getValue_departtype());
			}
		}
		if (form.getOp_momid().indexOf("NULL") != -1) {
			searchConds.add("momid " + form.getOp_momid());
		} else if (form.getValue_momid() != null) {
			searchConds.add("momid " + form.getOp_momid() + " :momid");
			if (form.getOp_momid().indexOf("LIKE") != -1) {
				if (!form.getValue_momid().startsWith("%")
						&& !form.getValue_momid().endsWith("%")) {
					searchParams
							.put("momid", "%" + form.getValue_momid() + "%");
				} else {
					searchParams.put("momid", form.getValue_momid());
				}
			} else {
				searchParams.put("momid", form.getValue_momid());
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

		if (form.getOp_sex().indexOf("NULL") != -1) {
			searchConds.add("sex " + form.getOp_sex());
		} else if (form.getValue_sex() != null) {
			searchConds.add("sex " + form.getOp_sex() + " :sex");
			searchParams.put("sex", Character.valueOf(form.getValue_sex()
					.charAt(0)));
		}

		if (form.getOp_firstborn().indexOf("NULL") != -1) {
			searchConds.add("firstborn " + form.getOp_firstborn());
		} else if (form.getValue_firstborn() != null) {
			searchConds.add("firstborn " + form.getOp_firstborn()
					+ " :firstborn");
			searchParams.put("firstborn", Character.valueOf(form
					.getValue_firstborn().charAt(0)));
		}
		
		if (searchConds.size() > 0) {
			sql = "select " + sql + " FROM Biography WHERE "
					+ StringUtils.join(searchConds, " AND ");

		} else {
			sql = "select " + sql + " FROM Biography ";
		}

		if (form.getSearchDistribution() != null && !groupby.equals("")) {
			sql += " GROUP BY " + groupby;
		}

		if (form.getSortBy() != null) {
			sql += " ORDER BY " + form.getSortBy();
			if (form.getOrder() != null)
				sql += " " + form.getOrder();
		}else{
			if (form.getSearchDistribution() == null|| groupby.equals("")) {
				sql += " ORDER BY studyid, animid";
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
				models.put("biographies", q.list());
				return new ModelAndView("biographyDownload", models);
			}

			q.setFirstResult(page * num_per_page);
			q.setMaxResults(num_per_page);
			
			models.put("biographies", q.list());

			return new ModelAndView("biographyList", models);
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
			throw new RuntimeException(
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
