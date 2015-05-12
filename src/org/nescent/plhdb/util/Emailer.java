package org.nescent.plhdb.util;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;

/**
 * Sends email messages
 * 
 */
public final class Emailer {

    public final static String CONTENT_TYPE_PLAIN = "text/plain";
    public final static String CONTENT_TYPE_HTML = "text/html";

    private static Logger log;

    private static Logger log() {
	if (log == null) {
	    log = Logger.getLogger(Emailer.class);
	}
	return log;
    }

    public static void sendEmail(String fromAddress, String toAddress,
	    String subject, String message, String type) {

	// Set the host smtp address
	Properties props = System.getProperties();

	props.put("mail.smtp.host", "smtp.duke.edu");
	props.put("mail.smtp.port", "25");

	// create some properties and get the default Session
	Session session = Session.getDefaultInstance(props, null);
	session.setDebug(true);
	// create a message
	Message msg = new MimeMessage(session);

	try {
	    // set the from and to address
	    InternetAddress addressFrom = new InternetAddress(fromAddress);
	    msg.setFrom(addressFrom);

	    InternetAddress addressTo = new InternetAddress(toAddress);

	    msg.setRecipient(Message.RecipientType.TO, addressTo);

	    // Setting the Subject and Content Type
	    msg.setSubject(subject);
	    msg.setContent(message, type);
	    Transport.send(msg);

	} catch (AddressException e) {
	    log().error("Unable to initialize email", e);
	    throw new IllegalArgumentException("bad email address", e);
	} catch (MessagingException e) {
	    log().error("Unable to initialize email", e);
	    throw new RuntimeException("Unable to initialize email", e);
	}

    }

}
