package org.nescent.plhdb.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.nescent.plhdb.aa.Permission;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Biography;
import org.nescent.plhdb.hibernate.dao.Studyinfo;
import org.nescent.plhdb.spring.AddStudyController;
import java.security.AccessControlException;


public class PrepareModel {
    private static Logger log;

    private static Logger log() {
	if (log == null) {
	    log = Logger.getLogger(AddStudyController.class);
	}
	return log;
    }

    @SuppressWarnings("unchecked")
    public static Map<String, Object> prepare(String study_id,
	    String individual_id, PermissionManager manager) {

	Session session = HibernateSessionFactory.getSession();
	//Transaction tx = session.beginTransaction();
	String sql = null;
	Query q = null;

	Map<String, Object> models = new HashMap<String, Object>();

	Studyinfo currentStudy = null;
	Biography currentIndividual = null;

	try {
	    sql = "FROM Studyinfo";
	    if (!manager.isAdmin()) {
			List permittedstudies = manager
				.getPermittedStudies(Permission.ACCESS_TYPE_UPDATE);
			if (permittedstudies.size() == 0) {
			    throw new AccessControlException(
				    "You do not have the authority to edit any studies.");
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
					where += "studyId ='" + std + "'";
			    }
			}
	
			if (!where.equals("")) {
			    sql += " WHERE " + where;
			}
	    }
	    sql += "  ORDER BY studyId";

	    q = session.createQuery(sql);
	    List studies = q.list();
	    models.put("studies", studies);

	    if (studies.size() > 0) {
			currentStudy = (Studyinfo) studies.get(0);
	    }

	    if (isValid(study_id)) {
			sql = "FROM Studyinfo WHERE studyId= :id";
			q = session.createQuery(sql);
			q.setString("id", study_id);
			List list = q.list();
			if (list.size() > 0) {
			    currentStudy = (Studyinfo) list.get(0);
			} else {
			    throw new IllegalArgumentException(
				    "failed to retrieve the study: " + study_id);
			}
	    }
	    if (isValid(individual_id)) {
			currentIndividual = (Biography) session.get(
				"org.nescent.plhdb.hibernate.dao.Biography", Integer
					.parseInt(individual_id));
	
			if (currentIndividual == null) {
			    throw new IllegalArgumentException(
				    "failed to retrieve the biography with id: "
					    + individual_id);
			}

			sql = "FROM Studyinfo WHERE studyId= :id";
			q = session.createQuery(sql);
			q.setString("id", currentIndividual.getStudyid());
			List list = q.list();
			if (list.size() > 0) {
			    currentStudy = (Studyinfo) list.get(0);
			} else {
			    throw new IllegalArgumentException(
				    "failed to retrieve the study: " + study_id);
			}

			models.put("tab", "biography");
	    }

	    if (currentStudy != null) {
			sql = "FROM Biography bio WHERE bio.studyid= :id ORDER BY lpad(bio.animid,16,'0')";
			q = session.createQuery(sql);
			q.setString("id", currentStudy.getStudyId());
			models.put("individuals", q.list());
	
			sql = "FROM Individual indv WHERE indv.study.studyId = :id ORDER BY indv.individualId";
			q = session.createQuery(sql);
			q.setString("id", currentStudy.getStudyId());
			models.put("moms", q.list());
	    }
	    
	    models.put("currentStudy", currentStudy);
	    models.put("currentIndividual", currentIndividual);

	    if (currentIndividual != null) {
			sql = "FROM Femalefertilityinterval ffi WHERE ffi.animOid= :animal_id  order by ffi.id.startdate,ffi.id.starttype";
			q = session.createQuery(sql);
			q.setInteger("animal_id", currentIndividual.getAnimOid());
			models.put("fertilities", q.list());
	    }
	    //session.flush();
	    //tx.commit();
	    return models;

	} catch (HibernateException he) {
	    log().error(
		    "failed to retrieve data from the database with study id: "
			    + study_id + ", individual id: " + individual_id,
		    he);
	    throw he;
	}
	/*
	finally {
	    if (!tx.wasCommitted())
		tx.rollback();
	}*/
}

    private static boolean isValid(String s) {
	return (s != null && !s.trim().equals(""));
    }

}
