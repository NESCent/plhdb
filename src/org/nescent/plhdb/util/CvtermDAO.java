package org.nescent.plhdb.util;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.Cvterm;

public class CvtermDAO {
    private static Logger log;

    private static Logger log() {
	if (log == null) {
	    log = Logger.getLogger(CvtermDAO.class);
	}
	return log;
    }
    public static Cvterm getCvterm(String name, String namespace){
	
	if(name==null || name.equals("")){
	    return null;
	}
	Session session=HibernateSessionFactory.getSession();
        String sql="FROM Cvterm WHERE name= :name AND namespace= :namespace";
	Query q=session.createQuery(sql);
	
	q.setString("name", name);
	q.setString("namespace", namespace);
	
	List result=q.list();
	if(result.size()==0){
	    log().error("failed to retrieve the cvterm: "+name + " with namespace: "+namespace);
	    throw new IllegalArgumentException("failed to retrieve the cvterm: "+name + " with namespace: "+namespace);
	}
	
	Cvterm term=(Cvterm)result.get(0);
	return term; 
    }
}
