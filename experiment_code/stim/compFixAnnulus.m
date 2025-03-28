function imageMat = compFixAnnulus(const)
% ----------------------------------------------------------------------
% imageMat = compFixAnnulus(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute circular annulus surrounding the fixation stimulus
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% imageMat: 3D-RGBA matrix of the rCosMask
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------
% 1 - opaque
% 0 = transparent
raised_cos = const.raised_cos;
cRf = const.aperture_blur * const.fix_out_rim_rad * 2;
[x, y] = meshgrid(0:const.noise_size-1, 0:const.noise_size-1);
xCtr = const.noise_size / 2;
yCtr = const.noise_size / 2;
imageMat = zeros(size(x, 1), size(y, 2));

for t = 1:size(raised_cos, 1)
    maxR = const.fix_out_rim_rad - (t-1) * (cRf / size(raised_cos, 1));
    minR = const.fix_out_rim_rad - t * (cRf / size(raised_cos, 1));
    circleFringeT = abs((y - yCtr).^2 + (x - xCtr).^2) <= maxR.^2 & abs((y - yCtr).^2 + (x - xCtr).^2) >= minR.^2;
    imageMat(circleFringeT) = raised_cos(t);
end

circleRest = abs((y - yCtr).^2 + (x - xCtr).^2) <= minR.^2 & abs((y - yCtr).^2 + (x - xCtr).^2) >= 0.^2;
imageMat(circleRest) = raised_cos(t);
imageMat = imageMat * 255;

end