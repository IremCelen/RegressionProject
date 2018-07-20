*Stat611 Project;
*7/16/2018;

proc import datafile="/folders/myshortcuts/myfolders_/YieldLossData.xlsx" 
		out=yield dbms=xlsx replace;
run;

*Model - overall;

proc glm data=yield plots=diagnostics;
	class Vacuum Operator Vendor Line RPM Flow;
	*Class specifies the indicator (dummy vars);
	model YieldLoss=RPM Temp1 Temp2 Flow Conc Line Vacuum Operator Vendor / 
		solution;
run;

*Stepwise selection based on PRESS;

proc glmselect data=yield plots=(asePlot Criteria);
	class Vacuum Operator Vendor Line RPM Flow;
	model YieldLoss=RPM Temp1 Temp2 Flow Conc Line Vacuum Operator Vendor / 
		selection=stepwise(select=SL choose=PRESS);
run;

*Stepwise selection with AIC;

proc glmselect data=yield plots=(asePlot Criteria);
	class Vacuum Operator Vendor Line RPM Flow;
	model YieldLoss=RPM Temp1 Temp2 Flow Conc Line Vacuum Operator Vendor / 
		selection=stepwise(select=SL choose=AIC);
run;

*Stepwise selection with BIC;

proc glmselect data=yield plots=(asePlot Criteria);
	class Vacuum Operator Vendor Line RPM Flow;
	model YieldLoss=RPM Temp1 Temp2 Flow Conc Line Vacuum Operator Vendor / 
		selection=stepwise(select=SL choose=BIC);
run;

*Stepwise selection with Cp;

proc glmselect data=yield plots=(asePlot Criteria);
	class Vacuum Operator Vendor Line RPM Flow;
	model YieldLoss=RPM Temp1 Temp2 Flow Conc Line Vacuum Operator Vendor / 
		selection=stepwise(select=SL choose=BIC);
run;

************************************************************
**********Question 2***************************************;

proc import datafile="/folders/myshortcuts/myfolders_/InverterData.xlsx" 
		out=invert dbms=xlsx replace;
run;

DATA invert2;
	SET invert;
	LOGTransient=log2(TransientPt);
	LOGLengthNMOS=log2(LengthNMOS);
RUN;

proc glm data=invert2 plots=diagnostics;
	class Setpoint;
	*Class specifies the indicator (dummy vars);
	model LOGTransient=WidthNMOS LOGLengthNMOS WidthPMOS LengthPMOS Setpoint / 
		solution;
	run;
	*Influence;

proc reg data=invert2;
	model LOGTransient=WidthNMOS LOGLengthNMOS WidthPMOS LengthPMOS Setpoint / 
		influence p r partial;
	run;

proc glm data=invert2 plots=diagnostics;
	model LOGVAR=Setpoint / solution;
	run;
	******;

proc import datafile="/folders/myshortcuts/myfolders_/Inv2.xlsx" out=inv2 
		dbms=xlsx replace;
run;

DATA inv2;
	SET inv2;
	LOGTransient=log2(TransientPt);
RUN;

proc reg data=inv2;
	model LOGTransient=WidthNMOS LengthNMOS WidthPMOS LengthPMOS Setpoint / 
		influence p r partial;
	run;

proc glm data=inv2 plots=diagnostics;
	class Setpoint;
	*Class specifies the indicator (dummy vars);
	model LOGTransient=WidthNMOS LengthNMOS WidthPMOS LengthPMOS Setpoint / 
		solution;
	run;
	*Stepwise selection with Cp;

proc glmselect data=inv2 plots=(asePlot Criteria);
	class Setpoint;
	model LOGTransient=WidthNMOS LengthNMOS WidthPMOS LengthPMOS Setpoint / 
		selection=stepwise(select=SL choose=BIC);
run;

*Stepwise selection with PRESS;

proc glmselect data=inv2 plots=(asePlot Criteria);
	class Setpoint;
	model LOGTransient=WidthNMOS LengthNMOS WidthPMOS LengthPMOS Setpoint / 
		selection=stepwise(select=SL choose=PRESS);
run;