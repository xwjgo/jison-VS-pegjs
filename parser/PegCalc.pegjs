START
    = _ e:EXPRESSION _ {return e;}

EXPRESSION
    = head:SUB_EXPR tail:(OP_1 SUB_EXPR)* {
        return tail.reduce(function (result, element) {
            if (element[0] === '+') return result + element[1];
            if (element[0] === '-') return result - element[1];
        }, head);
    }

SUB_EXPR
    = head:UNARY tail:(OP_2 FACTOR)* {
        return tail.reduce(function (result, element) {
            if (element[0] === '*') return result * element[1];
            if (element[0] === '/') return result / element[1];
        }, head);
    }

UNARY
    = sign:OP_1? factor:FACTOR _ {
        return sign === '-' ? -factor : factor;
    }

FACTOR
    = _ "(" _ expr:EXPRESSION _ ")" _ {return expr;}
    / NUM

NUM
    = _ head:[0-9]+ tail:('.' [0-9]+)? _ {
        var result = head.join('');
        if (tail && tail[1]) {
            result += '.' + tail[1].join('');
        }
        return parseFloat(result);
    } 

OP_1
    = _ op:[\+\-] _ {return op;}

OP_2
    = _ op:[\*\/] _ {return op;}

_ "whitespace"
    = [ \t\n\r]*