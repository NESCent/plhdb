package org.nescent.plhdb.spring;

import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.nescent.plhdb.hibernate.dao.UserAccount;
import org.nescent.plhdb.util.Emailer;
import org.nescent.plhdb.util.PWGen;
import org.nescent.plhdb.util.PasswordService;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class ResetPasswordController implements Controller {
    private static Logger log;

    private static Logger log() {
	if (log == null)
	    log = Logger.getLogger(ResetPasswordController.class);
	return log;
    }

    public ModelAndView handleRequest(HttpServletRequest request,
	    HttpServletResponse response) {
	String emailAddress = request.getParameter("emailAddress");
	boolean success = forgotPassword(emailAddress);
	if (!success) {
	    log().error("Failed to find email address: " + emailAddress);
	    request
		    .getSession()
		    .setAttribute(
			    "Message",
			    "Sorry, "
				    + emailAddress
				    + " is not in our system. "
				    + "Please try a different address or register a new account");
	} else {
	    request
		    .getSession()
		    .setAttribute(
			    "Message",
			    "Your password has been emailed to your email address on file.  Please consider changing your password after login.");
	}

	return new ModelAndView("resetpassword");
    }

    public boolean forgotPassword(String emailAddress) {

	Session session = HibernateSessionFactory.getSession();
	Transaction tx = session.beginTransaction();
	boolean success = false;
	try {

	    Query q = session
		    .createQuery("FROM org.nescent.plhdb.hibernate.dao.UserAccount where upper(email) = :email_address");
	    q.setParameter("email_address", emailAddress.toUpperCase());

	    Iterator iter = q.list().iterator();
	    if (iter.hasNext()) {
		UserAccount a = (UserAccount) iter.next();

		String password = PWGen.getPassword(8);
		a.setPassword(PasswordService.getInstance().encrypt(password));
		session.save(a);
		session.flush();

		String subject = "PLHDB: Reeset password";
		String from = "help@nescent.org";
		String message = "You have asked to reset your password to the PLHDB system. "
			+ "Your new (system-generated) password is: "
			+ password
			+ "\n\n"
			+ "In the event that you recalled your old password in the meantime, it "
			+ "will no longer be valid. Please login with the password given above "
			+ "and change it at your earliest convenience. If you have trouble "
			+ "logging in with your new password, please email help@nescent.org.\n\n"
			+ "The NESCent IT Team. ";

		Emailer.sendEmail(from, emailAddress, subject, message,
			Emailer.CONTENT_TYPE_PLAIN);
		success = true;
	    }

	    tx.commit();
	} catch (HibernateException he) {
	    log().error("failed to reset password for: " + emailAddress, he);
	    throw he;
	} finally {
	    if (tx.isActive() && !tx.wasCommitted())
		tx.rollback();
	}
	return success;
    }
}
