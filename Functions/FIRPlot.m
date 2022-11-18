function FIRPlot(x, y)
lgdstr = ["x[n]" "y[n]"];
plot(x)
hold on
plot(y)
grid on
title(["Input Signal with Values " num2str(x)])
legend(lgdstr)
xlabel('Time (Samples)')
ylabel('Magnitude')
hold off
end