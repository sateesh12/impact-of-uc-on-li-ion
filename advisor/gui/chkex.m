% use to check exhaust aftertreatment system operation

% Plot conversion efficiencies
figure
hold
plot(ex_cat_tmp_range,ex_cat_hc_frac*100,ex_cat_tmp_range,ex_cat_co_frac*100,ex_cat_tmp_range,ex_cat_nox_frac*100,ex_cat_tmp_range,ex_cat_pm_frac*100)
ylabel('Conversion Efficiency (%)');
xlabel ('Catalyst Temperature (C)');
set(gcf,'NumberTitle','off','Name','Exhaust Aftertreatment Performance')
title('Exhaust Aftertreatment Performance')
legend({'HC','CO','NOx','PM'},0)

%%%%%%%%%%%%%%%%%%%%
% revision history
%%%%%%%%%%%%%%%%%%%%
% 7/24/00:tm file created
