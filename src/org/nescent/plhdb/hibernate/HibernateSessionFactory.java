package org.nescent.plhdb.hibernate;

import java.sql.Connection;
import java.sql.DriverManager;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

/**
 * Configures and provides access to Hibernate sessions, tied to the current
 * thread of execution. Follows the Thread Local Session pattern, see
 * {@link http://community.jboss.org/wiki/SessionsAndTransactions }.
 */
public class HibernateSessionFactory {
	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(HibernateSessionFactory.class);
		}
		return log;
	}

	/**
	 * Location of hibernate.cfg.xml file. Location should be on the classpath
	 * as Hibernate uses #resourceAsStream style lookup for its configuration
	 * file. The default classpath location of the hibernate config file is in
	 * the default package. Use #setConfigFile() to update the location of the
	 * configuration file for the current session.
	 */
	private static String CONFIG_FILE_LOCATION = "/hibernate.cfg.xml";
	private static Configuration configuration = new Configuration();
	private static SessionFactory sessionFactory;
	private static String configFile = CONFIG_FILE_LOCATION;

	private HibernateSessionFactory() {
	}

       /**
        * Create if necessary, and return the singleton Hibernate SessionFactory.
        */
	public static SessionFactory getSessionFactory() {
            if (sessionFactory == null) {
		try {
			configuration.configure(configFile);
			sessionFactory = configuration.buildSessionFactory();
		} catch (HibernateException he) {
			log().error("failed to create SessionFactory");
			throw he;
		}
            }
            return sessionFactory;
	}

	/**
	 * Obtains the current Hibernate Session instance. Auto-initializes the
	 * <code>SessionFactory</code> if needed.
	 * 
	 * @return Session
	 * @throws HibernateException
	 */
	public static Session getSession() throws HibernateException {
            return getSessionFactory().getCurrentSession();
	}

	/**
	 * Update the location of the Hibernate config file. The
	 * SessionFactory will automatically be rebuilt in the next
	 * call
	 */
	public static void setConfigFile(String file) {
		configFile = file;
		sessionFactory = null;
	}
}