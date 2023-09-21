\\\\\\LIVE
\\\\\\\CODE
\\\\\\\\YOUR
\\\\\\MODULAR

JIT LIBRARY (JUST IN TIME)

https://github.com/theseanco/howto_co34pt_liveCode


// SERVER SETUP
o = ServerOptions.new;
o.numOutputBusChannels = 10;
o.numInputBusChannels = 8;
o.memSize = 2**18;
s.options = o;

// PROXY SPACE SETUP
p = ProxySpace.push(s.boot);
p.makeTempoClock(2.0);p.quant=0;

s.scope
// >>
p.clock.tempo=13.5/6;
~metro={LFPulse.ar(~tempo.kr)*0.5};
~metro.quant=1;~metro.play(9);

s.scope
//
// 2-channels >> optomix strike
// gen
~track_1.quant=1;~track_1={LFNoise0.ar(~tempo.kr!2)}
~track_1.play(4)

// subgen_1
~track_1.quant=1;~track_1={var a=~tempo.kr;LFNoise0.ar([a,a*1.002])}

// subgen_2
~track_1.quant=1;~track_1={var a=~tempo.kr;LFNoise0.ar(9.rand*[a,a*1.002])}

// subgen_3
~track_1.fadeTime=1;
~track_1.quant=1;~track_1={LFNoise2.ar({200.rand}!2,0.5,0.5)}


p.clock.tempo=11/3;
// trig >> env >> optomix cntrl
// trig/env >> optomix cntrl
a=[1];~track_2.quant=1;~track_2={var trig=TDuty.ar(Dseq(a/~tempo.kr,inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.01).ar(0,trig)*SinOsc.ar(1)};~track_2.play(2);

a=[3/2];~track_3.quant=1;~track_3={var trig=TDuty.ar(Dseq(a/~tempo.kr,inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.01).ar(0,trig)*SinOsc.ar(2)};~track_3.play(3);


// global fx
~track_13.fadeTime=4
~track_13={CombC.ar(In.ar(15),1,{0.6.rand}!2,2.5)*1.0};

~track_13={FreeVerb.ar(In.ar(15),[2.05,2.9],0.5)*1.0};

// mod source
~track_5={SinOsc.ar(2000.rand)*0.91}
~track_5.play(8)


// two channels env >> tallin linear
// gen
~track_6={var trig =Dust.ar(2!2);Env.perc(0.1,0.6).ar(0,trig)*0.9}
~track_6.play(6)
~track_6.clear

// subgen_1
~track_6={var trig =Dust.ar(8!2);Env.perc(0.1,0.1).ar(0,trig)*0.9}
~track_6.play(6)
~track_6.clear

// subgen_2
~track_6={var trig =Dust.ar(40!2);Env.perc(0.01,0.01).ar(0,trig)*0.9}
~track_6.play(6)
~track_6.clear


// subgen_3
~track_6={var trig =Impulse.ar(1/1!2);Env.perc(0.01,0.2).ar(0,trig)*0.9}
~track_6.play(6)
~track_6.clear


//


a=[1];
a=1/(1+{5.rand})!8;
a=1/(1+{5.rand})!54;
~track_5.quant=1;~track_5={var trig=TDuty.ar(Dseq(a/~tempo.kr,inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.01).ar(0,trig)};~track_5.play(4);

a=[3/2];~track_6.quant=1;~track_6={var trig=TDuty.ar(Dseq(a/~tempo.kr,inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.01).ar(0,trig)};~track_6.play(3);


b=Buffer.readChannel(s,"/Volumes/XxX/wav/voice/Sean_Booth.wav");
~track_4={BufRd.ar(1,b,Phasor.ar(0,BufRateScale.kr(b),0, BufFrames.kr(b)))*5};~track_4.play(7)
~track_4.release(0.1)
s.scope




// tempo var kck
a=[1];~track_1.quant=[1,0.05];~track_1={var trig=TDuty.ar(Dseq(a/~tempo.kr,inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.01).ar(0,DelayC.ar(trig,1.0,SinOsc.ar(0.1,0,0.125,0.125)))};~track_1.play(8);

a=[2];~track_2.quant=1;~track_2={var trig=TDuty.ar(Dseq(a/~tempo,inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.3).ar(0,trig)};~track_2.play(9);

// rndm sub hat
a=[1/6.rand];~track_3.quant=1;~track_3={var trig=TDuty.ar(Dseq(a.pyramid/~tempo,inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.01).ar(0,trig)};~track_3.play(4);

////////////////////////////////////////////////////////
//////////////////////////////////////////////////////



// sustain controlled techno kick
a=[1];~track_1.quant=[1,0.05];~track_1={var trig=TDuty.ar(Dseq(a/~tempo.kr,inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.01).ar(0,DelayC.ar(trig,1.0,0))};~track_1.play(2);
a=[2/3];~track_2.quant=1;~track_2={var trig=TDuty.ar(Dseq(a/~tempo,inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.3).ar(0,trig)};~track_2.play(3);


// mod source
~track_5={LFNoise2.ar(1)*0.3}
~track_5={SinOsc.ar(200.rand)*0.1}
~track_5.play(8)

~track_6={Saw.ar(3)*0.9};~track_6.play(8)
~track_7={1.0-Saw.ar(2.2)*0.9};~track_7.play(8)

s.scope

// twin trigger
p.clock.tempo=1.05;~track_6.quant=1;~track_7.quant=1;
~track_6={Pulse.ar(5*~tempo.kr)*0.3};~track_6.play(6);
~track_7={1.0-SinOsc.ar(2.2*~tempo.kr)*0.9};~track_7.play(7)

// >> two channels gate/cv
~track_6={var trig =Impulse.ar(1);[trig,DC.ar(0.05)]*0.8}

~track_6={var trig =Impulse.ar(~tempo.kr*9);[trig,Demand.ar(trig,0,Drand((0.121*(1..16)/2.0)+0.0,inf))]*0.8}//cuasi_temp
~track_6={var trig =Impulse.ar(4);[trig,Demand.ar(trig,0,Drand(0.1*(-1..4),inf))]}
~track_6.play(8)
s.scope

// global fx
~track_13.fadeTime=4
~track_13={CombC.ar(In.ar(15),1,{0.6.rand}!2,30.5)*~cc_120};

~track_13={FreeVerb.ar(~track_5*0.5)*~cc_120};
~track_13={FreeVerb.ar(In.ar(15),[2.05,2.9],0.5)};~track_13.play
~track_13={GVerb.ar(In.ar(14),6,[0.5,0.6])*~cc_120};

// >> two channels gate/env
~track_6={var trig =Impulse.ar(1/2);[trig,Env.perc( 0.01,0.5).ar(0,trig)]*0.9}
~track_6.play(6)
~track_6.clear


p.clock.tempo=21.5/6;
a=[4.0,3.0];
~track_1.quant=1;~track_1={var trig=TDuty.ar(Dseq([Dseq(a/~tempo.kr,3),Dseq([7/3,7/3,7/3]/~tempo.kr,1)],inf), 0);DC.ar(1.0)*Env.perc(releaseTime:0.01).ar(0,trig)};~track_1.play(2);



// >> two channels gate/cv
a=[1/3,1/5]
~track_6.quant=1;~track_6={var trig=TDuty.ar(Dseq(a,inf));[trig*3,Demand.ar(trig,0,0.1+((0.1/12)*Drand((0,1..12),inf)))]}
~track_6.play(6)

p.clock.tempo=7/6;
~track_6={var trig=TDuty.ar(Dseq(a.pyramid/~tempo.kr,inf));[trig,Demand.ar(trig,0,0.1+((0.1/12)*Dseq([-5,-3,0,2,4,7,9,12,24,21],inf)))]}
~track_6.play(6)


