#extension GL_ARB_draw_buffers : enable
#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform sampler2D f_one_four;
uniform sampler2D f_five_eight;
uniform sampler2D velocity_current_density;
uniform sampler2D f_zero_prev_density;
uniform sampler2D height_boundary;
uniform vec2 offset;

float smoothstep(float edge0, float edge1, float x) {
  if(x < edge0){
      return 0.;
} else if( x > edge1){
     return 1.;
} else{
  return edge0 * (2. * pow(x, 3.) - 3. * pow(x, 2.) + 1.) + edge1 * (-2 * pow(x, 3.) + 3. * pow(x, 2.));
}
}

void main(){
  vec2 st = gl_TexCoord[0].st;
  vec4 tex1 = texture2D(f_one_four, st);
  vec4 tex2 = texture2D(f_five_eight, st);
  float ws = texture2D(f_zero_prev_density, st).a;
  float f0 = texture2D(f_zero_prev_density, st).r;
  float f1 = tex1.r;
  float f2 = tex1.g;
  float f3 = tex1.b;
  float f4 = tex1.a;
  float f5 = tex2.r;
  float f6 = tex2.g;
  float f7 = tex2.b;
  float f8 = tex2.a;
  vec2 e0 = vec2(0.0, 0.0);
  vec2 e1 = vec2(1.0, 0.0);
  vec2 e2 = vec2(0.0, -1.0);
  vec2 e3 = vec2(-1.0, 0.0);
  vec2 e4 = vec2(0.0, 1.0);
  vec2 e5 = e1 + e2;
  vec2 e6 = e2 + e3;
  vec2 e7 = e3 + e4;
  vec2 e8 = e4 + e1;

  float current_blocking_factor = texture2D(f_zero_prev_density, st).g;
  float isBoundary = texture2D(height_boundary, st).g;
  float evapRate = 0.1;
  float k_a = 0.;
  float new_f1 = 0.;
  float new_f2= 0.;
  float new_f3 = 0.;
  float new_f4 = 0.;
  float new_f5 = 0.;
  float new_f6= 0.;
  float new_f7= 0.;
  float new_f8= 0.;

  if(isBoundary < 1.0){
     float k_1 = texture2D(f_zero_prev_density, st - offset * e1).g;
     if (k_1 < 255.0){ //fluid-fluid
        k_a = 0.5 * current_blocking_factor + 0.5 * k_1;
        new_f1 = max(k_a * f1 + (1.0 - k_a) * texture2D(f_one_four, st- offset * e1).b, 0.);
     }
     else{ //fluid-boundary
         new_f1 = f3;
     }
     if(k_a == 1.0){
    new_f1 = max(new_f1 - isBoundary * evapRate, 0.);
  }
     float k_2 = texture2D(f_zero_prev_density, st - offset * e2).g;
     if (k_2 < 255.0){ //fluid-fluid
        k_a = 0.5 * current_blocking_factor + 0.5 * k_2;
        new_f2 = max(k_a * f2 + (1.0 - k_a) * texture2D(f_one_four, st- offset * e2).a, 0.);
     }
     else{ //fluid-boundary
         new_f2 = f4;
     }
       if(k_a == 1.0){
    new_f2 = max(new_f2 - isBoundary * evapRate, 0.);
  }
    float k_3 = texture2D(f_zero_prev_density, st - offset * e3).g;
     if (k_3 < 255.0){ //fluid-fluid
        k_a = 0.5 * current_blocking_factor + 0.5 * k_3;
        new_f3 = max(k_a * f3 + (1.0 - k_a) * texture2D(f_one_four, st- offset * e3).r, 0.);
     }
     else{ //fluid-boundary
         new_f3 = f1;
     }
      if(k_a == 1.0){
    new_f3 = max(new_f3 - isBoundary * evapRate, 0.);
  }
     float k_4 = texture2D(f_zero_prev_density, st - offset * e4).g;
     if (k_4 < 255.0){ //fluid-fluid
        k_a = 0.5 * current_blocking_factor + 0.5 * k_4;
        new_f4 = max(k_a * f4 + (1.0 - k_a) * texture2D(f_one_four, st- offset * e4).g, 0.);
     }
     else{ //fluid-boundary
         new_f4 = f2;
     }
       if(k_a == 1.0){
    new_f4 = max(new_f4 - isBoundary * evapRate, 0.);
  }
     float k_5 = texture2D(f_zero_prev_density, st - offset * e5).g;
     if (k_5 < 255.0){ //fluid-fluid
        k_a = 0.5 * current_blocking_factor + 0.5 * k_5;
        new_f5 = max(k_a * f5 + (1.0 - k_a) * texture2D(f_five_eight, st- offset * e5).b, 0.);
     }
     else{ //fluid-boundary
         new_f5 = f7;
     }
      if(k_a == 1.0){
    new_f5 = max(new_f5 - isBoundary * evapRate, 0.);
  }
     float k_6 = texture2D(f_zero_prev_density, st - offset * e6).g;
     if (k_6 < 255.0){ //fluid-fluid
        k_a = 0.5 * current_blocking_factor + 0.5 * k_6;
        new_f6 = max(k_a * f6 + (1.0 - k_a) * texture2D(f_five_eight, st- offset * e6).a, 0.);
     }
     else{ //fluid-boundary
         new_f6 = f8;
     }
      
  if(k_a == 1.0){
    new_f6 = max(new_f6 - isBoundary * evapRate, 0.);
  }

     float k_7 = texture2D(f_zero_prev_density, st - offset * e7).g;
     if (k_7 < 255.0){ //fluid-fluid
        k_a = 0.5 * current_blocking_factor + 0.5 * k_7;
        new_f7 = max(k_a * f7 + (1.0 - k_a) * texture2D(f_five_eight, st- offset * e7).r, 0.);
     }
     else{ //fluid-boundary
         new_f7 = f5;
     } 
       if(k_a == 1.0){
    new_f7 = max(new_f7 - isBoundary * evapRate, 0.);
  }

     float k_8 = texture2D(f_zero_prev_density, st - offset * e8).g;
     if (k_8 < 255.0){ //fluid-fluid
        k_a = 0.5 * current_blocking_factor + 0.5 * k_8;
        new_f8 = max(k_a * f8 + (1.0 - k_a) * texture2D(f_five_eight, st- offset * e8).g, 0.);
     }
     else{ //fluid-boundary
         new_f8 = f6;
     }
   if(k_a == 1.0){
    new_f8 = max(new_f8 - isBoundary * evapRate, 0.);
  }

}
else{
 float k_1 = texture2D(f_zero_prev_density, st - offset * e1).g;
 if (k_1 < 255.0){ //boundary-fluid
        new_f1 = 0.;
     }
     else{ //boundary-boundary
         new_f1 = 0.;
     }
      if(k_a == 1.0){
    new_f1 = max(new_f1 - isBoundary * evapRate, 0.);
  }
     float k_2 = texture2D(f_zero_prev_density, st - offset * e2).g;
 if (k_2 < 255.0){ //boundary-fluid
        new_f2 = 0.;
     }
     else{ //boundary-boundary
         new_f2 = 0.;
     }
       if(k_a == 1.0){
    new_f2 = max(new_f2 - isBoundary * evapRate, 0.);
  }
     float k_3 = texture2D(f_zero_prev_density, st - offset * e3).g;
 if (k_3 < 255.0){ //boundary-fluid
        new_f3 = 0.;
     }
     else{ //boundary-boundary
         new_f3 = 0.;
     }
      if(k_a == 1.0){
    new_f3 = max(new_f3 - isBoundary * evapRate, 0.);
  }
      float k_4 = texture2D(f_zero_prev_density, st - offset * e4).g;
 if (k_4 < 255.0){ //boundary-fluid
        new_f4 = 0.;
     }
     else{ //boundary-boundary
         new_f4 = 0.;
     }
       if(k_a == 1.0){
    new_f4 = max(new_f4 - isBoundary * evapRate, 0.);
  }
      float k_5 = texture2D(f_zero_prev_density, st - offset * e5).g;
 if (k_5 < 255.0){ //boundary-fluid
        new_f5 = 0.;
     }
     else{ //boundary-boundary
         new_f5 = 0.;
     }
      if(k_a == 1.0){
    new_f5 = max(new_f5 - isBoundary * evapRate, 0.);
  }
      float k_6 = texture2D(f_zero_prev_density, st - offset * e6).g;
 if (k_6 < 255.0){ //boundary-fluid
        new_f6 = 0.;
     }
     else{ //boundary-boundary
         new_f6 = 0.;
     }
      
  if(k_a == 1.0){
    new_f6 = max(new_f6 - isBoundary * evapRate, 0.);
  }

      float k_7 = texture2D(f_zero_prev_density, st - offset * e7).g;
 if (k_7 < 255.0){ //boundary-fluid
        new_f7 = 0.;
     }
     else{ //boundary-boundary
         new_f7 = 0.;
     }
       if(k_a == 1.0){
    new_f7 = max(new_f7 - isBoundary * evapRate, 0.);
  }

      float k_8 = texture2D(f_zero_prev_density, st - offset * e8).g;
 if (k_8 < 255.0){ //boundary-fluid
        new_f8 = 0.;
     }
     else{ //boundary-boundary
         new_f8 = 0.;
     }
  if(k_a == 1.0){
    new_f8 = max(new_f8 - isBoundary * evapRate, 0.);
  }

}
 
  vec2 u = e1 * new_f1 + e2 * new_f2 + e3 * new_f3 + e4 * new_f4 + e5 * new_f5 + e6 * new_f6 + e7 * new_f7 + e8 * new_f8;
  float new_density = f0 + new_f1 + new_f2 + new_f3 + new_f4 + new_f5 + new_f6 + new_f7 + new_f8;
  float es = 0.1;
  new_density = max(new_density - es, 0.);
  float new_wf = clamp(ws, 0.0, max(1.0 - new_density, 0.0));
  new_density = new_density + new_wf;


  float lambda = 0.5;
  float alpha = smoothstep(0., lambda, new_density);

  float f0_eq = (4./9.)*(new_density + alpha*(3.*dot(e0, u) + 9. * pow(dot(e0,u),2.)/2. - 3. * dot(u, u)/2.)); //wi = 4/9
  float f1_eq = (1./9.)*(new_density + alpha*(3.*dot(e1, u) + 9. * pow(dot(e1,u),2.)/2. - 3. * dot(u, u)/2.));
  float f2_eq = (1./9.)*(new_density + alpha*(3.*dot(e2,u) + 9. * pow(dot(e2,u),2.)/2. - 3. * dot(u, u)/2.));
  float f3_eq = (1./9.)*(new_density + alpha*(3.*dot(e3,u) + 9. * pow(dot(e3,u),2.)/2. - 3. * dot(u, u)/2.));
  float f4_eq = (1./9.)*(new_density + alpha*(3.*dot(e4,u) + 9. * pow(dot(e4,u),2.)/2. - 3. * dot(u, u)/2.));
  float f5_eq = (1./36.)*(new_density + alpha*(3.*dot(e5,u) + 9. * pow(dot(e5,u),2.)/2. - 3. * dot(u, u)/2.));
  float f6_eq = (1./36.)*(new_density + alpha*(3.*dot(e6,u) + 9. * pow(dot(e6,u),2.)/2. - 3. * dot(u, u)/2.));
  float f7_eq = (1./36.)*(new_density + alpha*(3.*dot(e7,u) + 9. * pow(dot(e7,u),2.)/2. - 3. * dot(u, u)/2.));
  float f8_eq = (1./36.)*(new_density + alpha*(3.*dot(e8,u) + 9. * pow(dot(e8,u),2.)/2. - 3. * dot(u, u)/2.));

  //update new distribution function
  float viscosity = 1.2; //viscosity change with different pigment color, here we take rose as an example
  float new_f0 = (1. - viscosity) * f0 + viscosity * f0_eq;
  new_f1 = (1.-viscosity)*new_f1 + viscosity*f1_eq;
  new_f2 = (1.-viscosity)*new_f2 + viscosity*f2_eq;
  new_f3 = (1.-viscosity)*new_f3 + viscosity*f3_eq;
  new_f4 = (1.-viscosity)*new_f4 + viscosity*f4_eq;
  new_f5 = (1.-viscosity)*new_f5 + viscosity*f5_eq;
  new_f6 = (1.-viscosity)*new_f6 + viscosity*f6_eq;
  new_f7 = (1.-viscosity)*new_f7 + viscosity*f7_eq;
  new_f8 = (1.-viscosity)*new_f8 + viscosity*f8_eq;



  gl_FragData[0] = vec4(new_f1, new_f2, new_f3, new_f4);
  gl_FragData[1] = vec4(new_f5, new_f6, new_f7, new_f8);
  gl_FragData[2] = vec4(u.x, u.y, new_density, new_wf);
  gl_FragData[3] = vec4(new_f0, texture2D(f_zero_prev_density, st).g, texture2D(f_zero_prev_density, st).b, ws);

}
