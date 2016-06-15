#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
char HMSG[]="Usage: %s -Mmodel -R<string> [-Oray.xy] -Praypara [-T]\n\
\n\
Description:\n\
    Compute ray path for layered models( format is (thickness vp vs)),\n\
    and the generated path file contains multiple segments seperate by\n\
    '> -Z1' for P segments and '> -Z-1' for S segmemts. Thus it is easy\n\
    to plot the path using 'psxy ... -C ...' using GMT.\n\
\n\
    -M: layered model.\n\
    -R: sequence of ray segments from the deepest interface. \n\
        'P' and 'S' represent downward path segments,\n\
        'p' and 's' represent upward path segments.\n\
        The coordinates of the end point is (0,0).\n\
   [-O]: output file for ray path.\n\
    -P: ray parameter(s/km).\n\
   [-T]: Only compute traveltime.\n\
\n\
Example:\n\
    To compute ray path below:\n\
    -----------------------------------------\n\
      s \\\n\
         \\                vp=4, vs=2.2, h=15\n\
    -----------------------------------------\n\
          p\\   S/\\p       vp=6, vs=3.5, h=25\n\
            \\  /  \\\n\
             \\/    \\\n\
    -----------------------------------------\n\
                     \\p   vp=8, vs=4.5, h=40\n\
                      \\\n\
    -----------------------------------------\n\
    model.file:\n\
    15.0   4.0   2.2\n\
    25.0   6.0   3.5\n\
    40.0   8.0   4.5\n\
\n\
    Command:\n\
    %s -Mmodel.file -RppSps -Oray.xy -P0.0833\n\
\n\
Wangsheng, IGG-CAS\n\
wangsheng.cas@gmail.com\n\
";

int main(int argc, char *argv[])
{
        int  fgmod = 0, fgRayPath = 0, fgout = 0, fgRP =0, fgT = 0;
        char *strmod, *strRayPath, *strout;
        FILE *fpmod,  *fpout;
        double rp;
        int i;
        char line[4096];
        int    Nlayer = 0;
        double *h, *vp, *vs;
        double *dxp, *dxs, *dtpH, *dtsH, *dtpA, *dtsA;
        double sinP, sinS, cosP, cosS;
        double dep = 0.0, x = 0.0, ttH = 0.0, ttA = 0.0;
        int    n = 0;
        char   lag;
        for(i = 1; i < argc ; ++i)
        {
                if(argv[i][0] == '-')
                {
                        switch(argv[i][1])
                        {
                                case 'M':
                                        strmod= &(argv[i][2]);
                                        fgmod = 1;
                                        break;
                                case 'R':
                                        strRayPath = &(argv[i][2]);
                                        fgRayPath = 1;
                                        break;
                                case 'O':
                                        strout = &(argv[i][2]);
                                        fgout = 1;
                                        break;
                                case 'P':
                                        sscanf(&(argv[i][2]),"%lf",&rp);
                                        fgRP = 1;
                                        break;
                                case 'T':
                                        fgT = 1;
                                        break;
                        }
                }
        }
        if(fgRP == 0 || (fgout == 0 && fgT == 0) || fgRayPath == 0 || fgmod == 0)
        {
                fprintf(stderr, HMSG, argv[0], argv[0]);
                exit(1);
        }
        if ( NULL == (fpmod = fopen(strmod,"r")) )
        {
                fprintf(stderr, "Err: Can't open file for read:  %s\n", strmod);
                exit(1);
        }
        if (fgT == 0)
        {
            if ( NULL == (fpout = fopen(strout,"w")) )
            {
                    fprintf(stderr, "Err: Can't open file for write: %s\n", strout);
                    exit(1);
            }
        }
        for (i = 0; ; ++i)
        {
                if( NULL == fgets(line, 4096, fpmod) )
                        break;
                ++Nlayer;
        }

        if (NULL == (h   = (double *) calloc(Nlayer, sizeof(double) )))
        {
                fprintf(stderr, "Err: Can't malloc memory!\n");
                exit(1);
        }
        if (NULL == (vp  = (double *) calloc(Nlayer, sizeof(double) )))
        {
                fprintf(stderr, "Err: Can't malloc memory!\n");
                exit(1);
        }
        if (NULL == (vs  = (double *) calloc(Nlayer, sizeof(double) )))
        {
                fprintf(stderr, "Err: Can't malloc memory!\n");
                exit(1);
        }
        if (NULL == (dxp = (double *) calloc(Nlayer, sizeof(double) )))
        {
                fprintf(stderr, "Err: Can't malloc memory!\n");
                exit(1);
        }
        if (NULL == (dxs = (double *) calloc(Nlayer, sizeof(double) )))
        {
                fprintf(stderr, "Err: Can't malloc memory!\n");
                exit(1);
        }
        if (NULL == (dtsH = (double *) calloc(Nlayer, sizeof(double) )))
        {
                fprintf(stderr, "Err: Can't malloc memory!\n");
                exit(1);
        }
        if (NULL == (dtpH = (double *) calloc(Nlayer, sizeof(double) )))
        {
                fprintf(stderr, "Err: Can't malloc memory!\n");
                exit(1);
        }
        if (NULL == (dtpA = (double *) calloc(Nlayer, sizeof(double) )))
        {
                fprintf(stderr, "Err: Can't malloc memory!\n");
                exit(1);
        }
        if (NULL == (dtsA = (double *) calloc(Nlayer, sizeof(double) )))
        {
                fprintf(stderr, "Err: Can't malloc memory!\n");
                exit(1);
        }
        //////////////////////////
        fseek(fpmod,0,SEEK_SET);
        for (i = 0; i < Nlayer ; ++i)
        {
                memset(line,0,4096);
                fgets(line, 4096, fpmod);
                sscanf(line,"%lf %lf %lf", &(h[i]), &(vp[i]), &(vs[i]));
        }
        for (i = 0; i < Nlayer; ++i)
        {
                sinP = rp * vp[i];
                cosP = sqrt(1.0 - sinP * sinP);
                sinS = rp * vs[i];
                cosS = sqrt(1.0 - sinS * sinS);

                dxp[i] = h[i] * sinP / cosP;
                dxs[i] = h[i] * sinS / cosS;

                dtpH[i] = h[i] * cosP / vp[i];
                dtsH[i] = h[i] * cosS / vs[i];

                dtpA[i] = dtpH[i] + dxp[i] * rp;
                dtsA[i] = dtsH[i] + dxs[i] * rp;
                //fprintf(stderr, "rp:%lf vp:%lf sinP:%lf\n", rp, vp[i], sinP );
                //fprintf(stderr, "  h:%lf cosP:%lf vp:%lf",h[i] , cosP , vp[i] );
                //fprintf(stderr, "  %d vp:%lf vs:%lf  %lf %lf\n", i, vp[i], vs[i], dtpH[i], dtsH[i]);
        }
        for ( ; *strRayPath != 0 ; ++strRayPath)
                ;
        --strRayPath;
        if(fgT == 1)
        {
                for ( ; ; --strRayPath)
                {
                        lag = *(strRayPath);
                        if( lag == 'R' )
                                break;
                        //printf("%c\n", lag);
                        if( lag == 'p' )
                        {
                                ttH += dtpH[n];
                                ttA += dtpA[n];
                                ++n;
                        }
                        else if( lag == 's' )
                        {
                                ttH += dtsH[n];
                                ttA += dtsA[n];
                                ++n;
                        }
                        else if( lag == 'P' )
                        {
                                --n;
                                ttH += dtpH[n];
                                ttA += dtpA[n];
                        }
                        else if( lag == 'S' )
                        {
                                --n;
                                ttH += dtsH[n];
                                ttA += dtsA[n];
                        }
                }
        }
        else if(fgT == 0)
        {
                for ( ; ; --strRayPath)
                {
                        lag = *(strRayPath);
                        if( lag == 'R' )
                                break;
                        //printf("%c\n", lag);
                        if( lag == 'p' )
                        {
                                fprintf(fpout, "> -Z1\n");
                                fprintf(fpout, "%lf %lf\n", x, dep );
                                x   += dxp[n];
                                dep += h[n];
                                ttH += dtpH[n];
                                ttA += dtpA[n];
                                ++n;
                                fprintf(fpout, "%lf %lf\n", x, dep );
                        }
                        else if( lag == 's' )
                        {
                                fprintf(fpout, "> -Z-1\n");
                                fprintf(fpout, "%lf %lf\n", x, dep );
                                x   += dxs[n];
                                dep += h[n];
                                ttH += dtsH[n];
                                ttA += dtsA[n];
                                ++n;
                                fprintf(fpout, "%lf %lf\n", x, dep );
                        }
                        else if( lag == 'P' )
                        {
                                fprintf(fpout, "> -Z1\n");
                                fprintf(fpout, "%lf %lf\n", x, dep );
                                --n;
                                x   += dxp[n];
                                dep -= h[n];
                                ttH += dtpH[n];
                                ttA += dtpA[n];
                                fprintf(fpout, "%lf %lf\n", x, dep );
                        }
                        else if( lag == 'S' )
                        {
                                fprintf(fpout, "> -Z-1\n");
                                fprintf(fpout, "%lf %lf\n", x, dep );
                                --n;
                                x   += dxs[n];
                                dep -= h[n];
                                ttH += dtsH[n];
                                ttA += dtsA[n];
                                fprintf(fpout, "%lf %lf\n", x, dep );
                        }
                }
        }


        fprintf(stdout, "Vertical Traveltime: %lf Traveltime: %lf\n", ttH, ttA );
        free(h);
        free(vp);
        free(vs);
        free(dxp);
        free(dxs);
        free(dtpH);
        free(dtpA);
        free(dtsH);
        free(dtsA);
        fclose(fpmod);
        if( fgT == 0)
            fclose(fpout);
        return 0;
}