import ceylon.time.base { Range, UnitOfTime, milliseconds }
import ceylon.time.internal { nextByStep, previousByStep, gapUtil = gap, overlapUtil = overlap }

see( Range )
shared class TimeRange( from, to, step = milliseconds ) satisfies Range<Time, TimeRange> {

    shared actual Time from;
    shared actual Time to;
    shared actual UnitOfTime step;

    shared actual Period period  {
        return from.periodTo(to);	
    }

    shared actual Duration duration  {
        return Duration(to.millisecondsOfDay - from.millisecondsOfDay);	
    }

    shared actual Boolean equals( Object other ) {
        return Range::equals(other); 
    }

    shared actual TimeRange? overlap(TimeRange other) {
        assert( is TimeRange? response = overlapUtil(this, other, step));
        return response;
    }

    shared actual TimeRange? gap( TimeRange other ) {
        assert( is TimeRange? response  = gapUtil(this, other, step));
        return response;
    }

    "An iterator for the elements belonging to this 
     container. where each jump is based on actual step of this Range"
    shared actual Iterator<Time> iterator()  {
        object listIterator satisfies Iterator<Time> {
            variable Integer count = 0;
            shared actual Time|Finished next() {
                value date = from > to then previousByStep(from, step, count++) else nextByStep(from, step, count++);
                assert( is Time date );
                value continueLoop = from <= to then date <= to else date >= to && date <= from;
                return continueLoop then date else finished;
            }
        }
        return listIterator;
    }
    
    "Define how this Range will get next or previous element while iterating."
    shared TimeRange stepBy( UnitOfTime step ) {
        return step == this.step then this else TimeRange(from, to, step);
    }

}