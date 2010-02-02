package org.nescent.plhdb.util;

import java.util.List;

/**
 * Various utility methods that still seem to be absent from the Java SDK.
 */
public class StringUtils {


    /**
     * Concatenates all the elements in the given list of strings, using the
     * given delimiter.
     */
    public static String join(List<String> list, String delim) {
        StringBuffer sb = join(list.toArray(new String[0]), 
                               delim, 
                               new StringBuffer());
        return sb.toString();
    }

    /**
     * Concatenates all the elements in the given array, using the
     * given delimiter.
     */
    public static String join(String[] array, String delim) {
        StringBuffer sb = join(array, delim, new StringBuffer());
        return sb.toString();
    }

    /**
     * Concatenates all the elements in the given array, using the
     * given delimiter. The result is appended to the given string
     * buffer, which is therefore modified in place.
     */
    public static StringBuffer join(String[] array, 
                                    String delim, 
                                    StringBuffer sb ) {
        if (sb == null) sb = new StringBuffer();
        for (int i=0; i<array.length; i++ ) {
            if (i!=0) sb.append(delim);
            sb.append(array[i]);
        }
        return sb;
    }
}