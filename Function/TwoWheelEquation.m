function dxi = TwoWheelEquation(t,xi,t1,u1,u2)
    u1 = interp1(t1,u1,t);
    u2 = interp1(t1,u2,t);
    dxi = zeros(3,1);%�o�͂��x�N�g���Ƃ��Ē�`
    dxi(1) = cos(xi(3)) * u1;
    dxi(2) = sin(xi(3)) * u1;
    dxi(3) = u2;
end