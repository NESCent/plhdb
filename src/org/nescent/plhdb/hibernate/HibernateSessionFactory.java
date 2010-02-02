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
 * {@link http://hibernate.org/42.html }.
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
	private static final ThreadLocal<Session> threadLocal = new ThreadLocal<Session>();
	private static Configuration configuration = new Configuration();
	private static org.hibernate.SessionFactory sessionFactory;
	private static String configFile = CONFIG_FILE_LOCATION;
	
	private HibernateSessionFactory() {
	}

	
   
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

	/**
	 * Returns the ThreadLocal Session instance. Lazy initialize the
	 * <code>SessionFactory</code> if needed.
	 * 
	 * @return Session
	 * @throws HibernateException
	 */
    
   
	public static Session getSession() throws HibernateException {
		
		Session session = (Session) threadLocal.get();

		if (session == null || !session.isOpen()) {
			if (sessionFactory == null) {
				rebuildSessionFactory();
			}
			session = (sessionFactory != null) ? sessionFactory.openSession(): null;
			threadLocal.set(session);
		}
	
		return session;
		
	}
	
    
   
	/**
	 * Rebuild hibernate session factory
	 * 
	 */
	public static void rebuildSessionFactory() {
		try {
			configuration.configure(configFile);
			sessionFactory = configuration.buildSessionFactory();
		} catch (HibernateException he) {
			log().error("failed to create SessionFactory");
			throw he;
		}
	}

	public static Connection createConnection() throws HibernateException {
		try {
			String dbUrl=configuration.getProperty("hibernate.connection.url");
			String dbClass=configuration.getProperty("hibernate.connection.driver_class");
			String dbUser=configuration.getProperty("hibernate.connection.username");
			String dbPassword=configuration.getProperty("hibernate.connection.password");
			Class.forName(dbClass).newInstance();
			String url = dbUrl+"?user="+dbUser+"&password="+dbPassword;
		    
			Connection conn = DriverManager.getConnection(url);
			return conn;
		} catch (Exception e) {
			log().error("failed to create database connection");
			throw new HibernateException("failed to create database connection",e);
		}
	}
	
	/**
	 * Close the single hibernate session instance.
	 * 
	 * @throws HibernateException
	 */
	public static void closeSession() throws HibernateException {
		Session session = (Session) threadLocal.get();
		threadLocal.set(null);

		if (session != null) {
			session.close();
		}
	
		
		
	}

	/**
	 * return session factory
	 * 
	 */
//	public static org.hibernate.SessionFactory getSessionFactory() {
//		return sessionFactory;
//	}

	/**
	 * return session factory
	 * 
	 * session factory will be rebuilded in the next call
	 */
	public static void setConfigFile(String configFile) {
		HibernateSessionFactory.configFile = configFile;
		sessionFactory = null;
	}

	/**
	 * return hibernate configuration
	 * 
	 */
	public static Configuration getConfiguration() {
		return configuration;
	}

}