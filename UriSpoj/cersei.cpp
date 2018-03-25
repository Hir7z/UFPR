//Busca Ternária
//https://www.urionlinejudge.com.br/judge/pt/problems/view/1860

#include<bits/stdc++.h>

int n,x,h,z;
double v[100005][2];

double testemaior(double mid){
    double maior=0,j=0;
    for(int i = 0; i<n; i++){
        j = sqrt((v[i][0]-mid) * (v[i][0]-mid) + v[i][1]*v[i][1] );
        if(j > maior){
            maior = j;
            h = v[i][0];
            z = v[i][1];
        }
    }
    return maior;
}

double testemenor(double mid){
    double menor=INT_MAX,j=0;
    for(int i = 0; i<n; i++){
        j = sqrt((h-mid) * (h-mid) + z*z );
        if(j < menor)
            menor = j;
    }
    return menor;
}

int main(){
    scanf("%d %d",&n,&x);
    for(int i=0; i<n; i++)
        scanf("%lf %lf",&v[i][0],&v[i][1]);
    double l =0,r=x;
    double mid1 = l + (r - l)/3;
    double mid2 = mid1 + (r - l)/3;
    double maior1 = testemaior(mid1),maior2 = testemaior(mid2);
    
    if(maior1>maior2)
        l = mid1;
    else
        r = mid2;
    int o = 0;
    while(o <150){
        mid1 = l + (r - l)/3;
        mid2 = mid1 + (r - l)/3;
       /* double menor1 = testemenor(mid1),menor2 = testemenor(mid2);
        if(menor1 < menor2)
            r = mid2;
        else
            l = mid1;
        */
        double menor1 = testemaior(mid1),menor2 = testemaior(mid2);
        if(menor1>menor2)
            l = mid1;
        else
            r = mid2;
        o++;
    }
    double res = mid1<mid2 ? mid1 : mid2;
    double resdist = sqrt((h-res) * (h-res) + z*z );
    printf("%.2lf %.2lf\n",res,resdist);
    return 0;
}