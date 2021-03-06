"Combines two [[promises|Promise]] into a new promise.
 
 The new promise is
 
 - fulfilled when both promises are fulfilled, or
 - rejected when either of the two promises is rejected."
by("Julien Viet")
class Conjunction<out Element, out First, Rest>(first, rest)
    satisfies Term<Element,Tuple<First|Element,First,Rest>>
        given First satisfies Element
        given Rest satisfies Sequential<Element> {
    
    "The first promise."
    Promise<Rest> rest;
    
    "The second promise."
    Promise<First> first;

    value deferred = Deferred<Tuple<First|Element,First,Rest>>();
    promise = deferred.promise;
    
    variable First? firstVal = null;
    variable Rest? restVal = null;

    void check() {
        if (exists first = firstVal, exists rest = restVal) {
            deferred.fulfill(Tuple(first, rest));
        }
    }
    
    void onReject(Throwable e) {
        deferred.reject(e);
    }
    
    void onRestFulfilled(Rest val) {
        restVal = val;
        check();
    }
    rest.compose(onRestFulfilled, onReject);
    
    void onFirstFulfilled(First val) {
        firstVal = val;
        check();
    }
    first.compose(onFirstFulfilled, onReject);

    shared actual 
    Term<Element|Other,Tuple<Element|Other,Other,Tuple<First|Element,First,Rest>>> 
            and<Other>(Promise<Other> other) 
            => Conjunction(other, promise);

    shared actual Promise<Result> handle<Result>(
            Callable<Promise<Result>,Tuple<First|Element,First,Rest>> onFulfilled,
            Promise<Result>(Throwable) onRejected) 
            => promise.handle {
                (Tuple<First|Element,First,Rest> args) 
                        => unflatten(onFulfilled)(args);
                onRejected;
            };

}
