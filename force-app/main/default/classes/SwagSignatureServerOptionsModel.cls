/*
 * ESign API documentation V1
 * ESign application.
 *
 * OpenAPI spec version: 1
 * Contact: ext-ellouzi@em-lyon.com
 *
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen.git
 * Do not edit the class manually.
 */

/**
 * Class SignatureField.
 */
public class SwagSignatureServerOptionsModel {
    /**
     * 
     * @return profile
     */
    public String profile { get; set; }

    /**
     * 
     * @return reason
     */
    public String reason { get; set; }

    /**
     * 
     * @return location
     */
    public String location { get; set; }

    /**
     * 
     * @return signatureFormat
     */
    public String signatureFormat { get; set; }

    /**
     * Name of signature.
     * @return name
     */
    public String name { get; set; }

    /**
     * Page.
     * @return page
     */
    public Integer page { get; set; }

    /**
     * X.
     * @return x
     */
    public Integer x { get; set; }

    /**
     * Y
     * @return y
     */
    public Integer y { get; set; }

    /**
     * Pattern a applique sur la signature.
     * @return patternName
     */
    public String patternName { get; set; }

    /**
     * 
     * @return label
     */
    public String label { get; set; }

    /**
     * Image.
     * @return image
     */
    public Blob image { get; set; }

    public static SwagSignatureServerOptionsModel getExample() {
        SwagSignatureServerOptionsModel signatureServerOptionsModel = new SwagSignatureServerOptionsModel();
        signatureServerOptionsModel.profile = 'aeiou';
        signatureServerOptionsModel.reason = 'aeiou';
        signatureServerOptionsModel.location = 'aeiou';
        signatureServerOptionsModel.signatureFormat = 'aeiou';
        signatureServerOptionsModel.name = 'aeiou';
        signatureServerOptionsModel.page = 123;
        signatureServerOptionsModel.x = 123;
        signatureServerOptionsModel.y = 123;
        signatureServerOptionsModel.patternName = 'aeiou';
        signatureServerOptionsModel.label = 'aeiou';
        signatureServerOptionsModel.image = EncodingUtil.base64Decode('VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wZWQgb3ZlciB0aGUgbGF6eSBkb2cu');
        return signatureServerOptionsModel;
    }

    public Boolean equals(Object obj) {
        if (obj instanceof SwagSignatureServerOptionsModel) {
            SwagSignatureServerOptionsModel signatureServerOptionsModel = (SwagSignatureServerOptionsModel) obj;
            return this.profile == signatureServerOptionsModel.profile
                && this.reason == signatureServerOptionsModel.reason
                && this.location == signatureServerOptionsModel.location
                && this.signatureFormat == signatureServerOptionsModel.signatureFormat
                && this.name == signatureServerOptionsModel.name
                && this.page == signatureServerOptionsModel.page
                && this.x == signatureServerOptionsModel.x
                && this.y == signatureServerOptionsModel.y
                && this.patternName == signatureServerOptionsModel.patternName
                && this.label == signatureServerOptionsModel.label
                && this.image == signatureServerOptionsModel.image;
        }
        return false;
    }

    public Integer hashCode() {
        Integer hashCode = 43;
        hashCode = (17 * hashCode) + (profile == null ? 0 : System.hashCode(profile));
        hashCode = (17 * hashCode) + (reason == null ? 0 : System.hashCode(reason));
        hashCode = (17 * hashCode) + (location == null ? 0 : System.hashCode(location));
        hashCode = (17 * hashCode) + (signatureFormat == null ? 0 : System.hashCode(signatureFormat));
        hashCode = (17 * hashCode) + (name == null ? 0 : System.hashCode(name));
        hashCode = (17 * hashCode) + (page == null ? 0 : System.hashCode(page));
        hashCode = (17 * hashCode) + (x == null ? 0 : System.hashCode(x));
        hashCode = (17 * hashCode) + (y == null ? 0 : System.hashCode(y));
        hashCode = (17 * hashCode) + (patternName == null ? 0 : System.hashCode(patternName));
        hashCode = (17 * hashCode) + (label == null ? 0 : System.hashCode(label));
        hashCode = (17 * hashCode) + (image == null ? 0 : System.hashCode(image));
        return hashCode;
    }
}