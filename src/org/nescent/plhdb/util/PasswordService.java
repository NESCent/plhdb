package org.nescent.plhdb.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.apache.log4j.Logger;

import sun.misc.BASE64Encoder;

public final class PasswordService {
    private static Logger log;

    private static Logger log() {
	if (log == null) {
	    log = Logger.getLogger(PasswordService.class);
	}
	return log;
    }

    private static PasswordService instance;

    private PasswordService() {
    }

    public synchronized String encrypt(String plaintext) {
	MessageDigest md = null;
	try {
	    md = MessageDigest.getInstance("SHA");
	    md.update(plaintext.getBytes("UTF-8"));
	} catch (NoSuchAlgorithmException e) {
	    log().error("failed to encrypt the password.", e);
	    throw new RuntimeException("failed to encrypt the password.", e);
	} catch (UnsupportedEncodingException e) {
	    log().error("failed to encrypt the password.", e);
	    throw new RuntimeException("failed to encrypt the password.", e);
	}
	byte raw[] = md.digest();
	String hash = (new BASE64Encoder()).encode(raw);
	return hash;
    }

    public static synchronized PasswordService getInstance() {
	if (instance == null) {
	    return new PasswordService();
	} else {
	    return instance;
	}
    }
}
