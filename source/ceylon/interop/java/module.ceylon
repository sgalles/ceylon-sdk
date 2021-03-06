"A set of adaptors for types belonging to the Java language
 or Java SDK. Includes:
 
 - a set of functions for converting between Ceylon's 
   [[Array]] class and Java array types, for example,
   [[javaIntArray]], [[javaFloatArray]], [[javaByteArray]],
   [[javaBooleanArray]], [[javaObjectArray]], and
   [[javaStringArray]],
 - classes adapting Java collection types to Ceylon 
   collection interfaces: [[CeylonList]], [[CeylonSet]], 
   [[CeylonMap]],
 - classes adapting Ceylon collection types to Java 
   collection interfaces: [[JavaList]], [[JavaSet]],
   [[JavaMap]], and
 - [[CeylonIterable]] and [[JavaIterable]] which adapt 
   between Java's [[java.lang::Iterable]] interface and 
   Ceylon's [[Iterable]] interface,
 - [[JavaCloseable]] and [[CeylonDestroyable]] which adapt
   between [[java.lang::AutoCloseable]] and [[Destroyable]].
   
 In addition, the functions [[javaClass]] and 
 [[javaClassFromInstance]] allow Ceylon programs to obtain
 an instance of [[java.lang::Class]]."
by("The Ceylon Team")
module ceylon.interop.java "1.1.0" {
    shared import java.base "7";
    shared import ceylon.collection "1.1.0";
}
