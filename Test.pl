%not
check([[s0, [s1]],
 [s1, [s0]]],[[s0, [r]],
 [s1, [q]]], s0,[], neg(q)).


%And
 check([[s0, [s1]],
  [s1, [s0]]],[[s0, [q,r]],
  [s1, [q]]], s0,[], and(q,r)).

%or
check([[s0, [s1]],
 [s1, [s0]]],[[s0, [r]],
 [s1, [q]]], s0,[], or(q,r)).

%AX
check([[s0, [s1]],
 [s1, [s0]]],[[s0, [r]],
 [s1, [q]]], s0, [], ax(q)).

%EX
check([[s0, [s1]],
 [s1, [s0]]],[[s0, [r]],
 [s1, [q]]], s0, [], ex(q)).

%AF
check([[s0, [s1]],
 [s1, [s0]]],[[s0, [r]],
 [s1, [q]]], s0, [], af(q)).

%EF
check([[s0, [s1]],
 [s1, [s0]]],[[s0, [r]],
 [s1, [q]]], s0, [], ef(q)).

%AG
check([[s0, [s1]],
 [s1, [s0]]],[[s0, [q,r]],
 [s1, [q]]], s0, [], ag(q)).

%eg
check([[s0, [s1]],
 [s1, [s0]]],[[s0, [q,r]],
 [s1, [q]]], s0, [], eg(q)).
%p
check([[s0, [s1]],
 [s1, [s0]]],[[s0, [r]],
 [s1, [q]]], s0, [],r).
