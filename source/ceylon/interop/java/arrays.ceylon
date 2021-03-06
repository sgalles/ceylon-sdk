import java.lang {
    Char=Character,
    Bool=Boolean,
    Bits=Byte,
    Short,
    Int=Integer,
    Long,
    Single=Float,
    Double,
    JavaString=String,
    FloatArray,
    DoubleArray,
    ByteArray,
    ShortArray,
    IntArray,
    LongArray,
    ObjectArray,
    BooleanArray,
    CharArray
}

import ceylon.interop.java.internal {
    booleanArray=javaBooleanArray,
    byteArray=javaByteArray,
    charArray=javaCharArray,
    doubleArray=javaDoubleArray,
    floatArray=javaFloatArray,
    intArray=javaIntArray,
    longArray=javaLongArray,
    shortArray=javaShortArray,
    objectArray=javaObjectArray,
    stringArray=javaStringArray
}


"The [[BooleanArray]], that is, the Java `boolean[]` array, 
 underyling the given Ceylon [[array]]. Changes made to this
 Java array will be reflected in the given [[Array]] and 
 vice versa."
shared BooleanArray javaBooleanArray(Array<Boolean>|Array<Bool> array)
        => booleanArray(array);

"The [[ByteArray]], that is, the Java `byte[]` array 
 underyling the given Ceylon [[array]].  Changes made to 
 this Java array will be reflected in the given [[Array]] 
 and vice versa."
shared ByteArray javaByteArray(Array<Byte>|Array<Bits> array)
        => byteArray(array);

"The [[ShortArray]], that is, the Java `short[]` array 
 underyling the given Ceylon [[array]].  Changes made to 
 this Java array will be reflected in the given [[Array]] 
 and vice versa."
shared ShortArray javaShortArray(Array<Short> array)
        => shortArray(array);

"The [[IntArray]], that is, the Java `int[]` array 
 underyling the given Ceylon [[array]].  Changes made to 
 this Java array will be reflected in the given [[Array]] 
 and vice versa."
shared IntArray javaIntArray(Array<Character>|Array<Int> array)
        => intArray(array);

"The [[LongArray]], that is, the Java `long[]` array 
 underyling the given Ceylon [[array]].  Changes made to 
 this Java array will be reflected in the given [[Array]] 
 and vice versa."
shared LongArray javaLongArray(Array<Integer>|Array<Long> array)
        => longArray(array);

"The [[FloatArray]], that is, the Java `float[]` array 
 underyling the given Ceylon [[array]]. Changes made to this
 Java array will be reflected in the given [[Array]] and 
 vice versa."
shared FloatArray javaFloatArray(Array<Single> array)
        => floatArray(array);

"The [[DoubleArray]], that is, the Java `double[]` array 
 underyling the given Ceylon [[array]]. Changes made to this
 Java array will be reflected in the given [[Array]] and 
 vice versa."
shared DoubleArray javaDoubleArray(Array<Float>|Array<Double> array)
        => doubleArray(array);

"The [[CharArray]], that is, the Java `char[]` array 
 underyling the given Ceylon [[array]]. Changes made to this
 Java array will be reflected in the given [[Array]] and 
 vice versa."
shared CharArray javaCharArray(Array<Char> array)
        => charArray(array);

"The [[ObjectArray]], that is, the Java `Object[]` array 
 underyling the given Ceylon [[array]]. Changes made to this
 Java array will be reflected in the given [[Array]] and 
 vice versa."
shared ObjectArray<Element> javaObjectArray<Element>(Array<Element?> array)
        given Element satisfies Object
        => objectArray(array);

"The [[string array|ObjectArray]], that is, the Java 
 `String[]` array underyling the given Ceylon [[array]]. 
 Changes made to this Java array will be reflected in the 
 given [[Array]] and vice versa."
shared ObjectArray<JavaString> javaStringArray(Array<String> array)
        => stringArray(array);

"An array whose elements can be represented as an 
 `Array<Integer>`."
shared alias IntegerArrayLike 
        => Array<Short> | Array<Int> | Array<Long>
        | ShortArray   | IntArray   | LongArray;

"Create a new `Array<Integer>` with the same elements as the
 given [[array]]."
shared Array<Integer> toIntegerArray(IntegerArrayLike array) {
    switch (array)
    case (is Array<Short>) {
        value size = array.size;
        value nativeArray = javaShortArray(array);
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, nativeArray.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is Array<Int>) {
        value size = array.size;
        value nativeArray = javaIntArray(array);
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, nativeArray.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is Array<Long>) {
        value size = array.size;
        value nativeArray = javaLongArray(array);
        value result = LongArray(size);
        nativeArray.copyTo(result);
        return result.integerArray;
    }
    case (is ShortArray) {
        value size = array.size;
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is IntArray) {
        value size = array.size;
        value result = LongArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i));
            i++;
        }
        return result.integerArray;
    }
    case (is LongArray) {
        value size = array.size;
        value result = LongArray(size);
        array.copyTo(result);
        return result.integerArray;
    }
}

"An array whose elements can be represented as an 
 `Array<Float>`."
shared alias FloatArrayLike 
        => Array<Single> | Array<Double>
        |  FloatArray    | DoubleArray;

"Create a new `Array<Float>` with the same elements as the
 given [[array]]."
shared Array<Float> toFloatArray(FloatArrayLike array) {
    switch (array)
    case (is Array<Single>) {
        value size = array.size;
        value nativeArray = javaFloatArray(array);
        value result = DoubleArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, nativeArray.get(i));
            i++;
        }
        return result.floatArray;
    }
    case (is Array<Double>) {
        value size = array.size;
        value nativeArray = javaDoubleArray(array);
        value result = DoubleArray(size);
        nativeArray.copyTo(result);
        return result.floatArray;
    }
    case (is FloatArray) {
        value size = array.size;
        value result = DoubleArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i));
            i++;
        }
        return result.floatArray;
    }
    case (is DoubleArray) {
        value size = array.size;
        value result = DoubleArray(size);
        array.copyTo(result);
        return result.floatArray;
    }
}

"An array whose elements can be represented as an 
 `Array<Byte>`."
shared alias ByteArrayLike 
        => Array<Bits> | ByteArray;

"Create a new `Array<Byte>` with the same elements as the
 given [[array]]."
shared Array<Byte> toByteArray(ByteArrayLike array) {
    switch (array)
    case (is Array<Bits>) {
        value size = array.size;
        value nativeArray = javaByteArray(array);
        value result = ByteArray(size);
        variable value i=0;
        while (i<size) {
            result.set(i, nativeArray.get(i));
            i++;
        }
        return result.byteArray;
    }
    case (is ByteArray) {
        value size = array.size;
        value result = ByteArray(size);
        array.copyTo(result);
        return result.byteArray;
    }
}


//Array<JavaString?> toJavaStringCeylonArray(StringArrayLike array)
//        => toJavaStringArray(array).array;

"An array whose elements can be represented as an 
 `Array<String?>`."
shared alias StringArrayLike 
        => ObjectArray<JavaString>
        |  Array<JavaString?>
        | Array<JavaString>;

"Create a new Ceylon string array, that is, an 
 `Array<String?>` with the same elements as the
 given array of [[Java strings|java.lang::String]]."
see (`function toJavaStringArray`)
shared Array<String?> toStringArray(StringArrayLike array) {
    ObjectArray<String> javaArray;
    switch (array)
    case (is ObjectArray<JavaString>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.get(i)?.string);
            i++;
        }
        javaArray = result;
    }
    case (is Array<JavaString?>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.getFromFirst(i)?.string);
            i++;
        }
        javaArray = result;
    }
    case (is Array<JavaString>) {
        value size = array.size;
        value result = ObjectArray<String>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, array.getFromFirst(i)?.string);
            i++;
        }
        javaArray = result;
    }
    return javaArray.array;
}

"An array whose elements can be represented as an 
 `ObjectArray<JavaString>`."
shared alias JavaStringArrayLike
        => ObjectArray<String>
        |  Array<String>
        | Array<String?>;

"Create a new Java [[string array|ObjectArray]], that is,
 a Java `String[]`, with the same elements as the given 
 array of [[Ceylon strings|String]]."
see (`function toStringArray`)
shared ObjectArray<JavaString> toJavaStringArray(JavaStringArrayLike array) {
    switch (array)
    case (is ObjectArray<String>) {
        value size = array.size;
        value result = ObjectArray<JavaString>(size);
        variable value i=0;
        while (i<size) {
            result.set(i, javaString(array.get(i)));
            i++;
        }
        return result;
    }
    case (is Array<String?>) {
        value size = array.size;
        value result = ObjectArray<JavaString>(size);
        variable value i=0;
        while (i<size) {
            if (exists element = array.getFromFirst(i)) {
                result.set(i, javaString(element));
            }
            i++;
        }
        return result;
    }
    case (is Array<String>) {
        value size = array.size;
        value result = ObjectArray<JavaString>(size);
        variable value i=0;
        while (i<size) {
            if (exists element = array.getFromFirst(i)) {
                result.set(i, javaString(element));
            }
            i++;
        }
        return result;
    }
}

"Create a new [[BooleanArray]], that is, a Java `boolean[]`
 array, with the given elements."
shared BooleanArray createJavaBooleanArray({Boolean*} booleans)
        => javaBooleanArray(Array(booleans));

"Create a new [[LongArray]], that is, a Java `long[]`
 array, with the given elements."
shared LongArray createJavaLongArray({Integer*} elements)
        => javaLongArray(Array(elements));

"Create a new [[IntArray]], that is, a Java `int[]`
 array, with the given elements."
shared IntArray createJavaIntArray({Integer*} elements)
        => javaIntArray(Array { for (i in elements) Int(i) });

"Create a new [[ShortArray]], that is, a Java `short[]`
 array, with the given elements."
shared ShortArray createJavaShortArray({Integer*} elements)
        => javaShortArray(Array { for (i in elements) Short(i) });

"Create a new [[ByteArray]], that is, a Java `byte[]`
 array, with the given elements."
shared ByteArray createJavaByteArray({Byte*} elements)
        => javaByteArray(Array { for (i in elements) i });

"Create a new [[FloatArray]], that is, a Java `float[]`
 array, with the given elements."
shared FloatArray createJavaFloatArray({Float*} elements)
        => javaFloatArray(Array { for (f in elements) Single(f) });

"Create a new [[DoubleArray]], that is, a Java `double[]`
 array, with the given elements."
shared DoubleArray createJavaDoubleArray({Float*} elements)
        => javaDoubleArray(Array(elements));

"Create a new [[string array|ObjectArray]], that is, a Java 
 `String[]` array, with the given elements."
shared ObjectArray<JavaString> createJavaStringArray({String*} elements)
        => javaStringArray(Array(elements));

"Create a new [[ObjectArray]], that is, a Java `Object[]`
 array, with the given elements."
shared ObjectArray<T> createJavaObjectArray<T>({T?*} elements)
        given T satisfies Object
        => javaObjectArray(Array(elements));
