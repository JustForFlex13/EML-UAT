/*
 * ESign ConvSta API documentation V1
 * ESign ConvSta API application.
 *
 * OpenAPI spec version: 1
 * Contact: ext-ellouzi@em-lyon.com
 *
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen.git
 * Do not edit the class manually.
 */

/**
 * SwagSignatureStatusResponse
 */
public class SwagSignatureStatusResponse implements Swagger.MappedProperties {
    /**
     * CutomId
     * @return customId
     */
    public String customId { get; set; }

    /**
     * Current Status.
     * @return currentStatus
     */
    public String currentStatus { get; set; }

    /**
     * HorodatageCurrentStatus.
     * @return horodatageCurrentStatus
     */
    public Datetime horodatageCurrentStatus { get; set; }

    /**
     * Liste des status des signataires.
     * @return signatairesStatus
     */
    public List<SwagSignatureSignataireStatus> signatairesStatus { get; set; }

    private static final Map<String, String> propertyMappings = new Map<String, String>{
        'CustomId' => 'customId',
        'CurrentStatus' => 'currentStatus',
        'HorodatageCurrentStatus' => 'horodatageCurrentStatus',
        'SignatairesStatus' => 'signatairesStatus'
    };

    public Map<String, String> getPropertyMappings() {
        return propertyMappings;
    }

    public SwagSignatureStatusResponse() {
        signatairesStatus = new List<SwagSignatureSignataireStatus>();
    }

    public static SwagSignatureStatusResponse getExample() {
        SwagSignatureStatusResponse signatureStatusResponse = new SwagSignatureStatusResponse();
        signatureStatusResponse.customId = 'aeiou';
        signatureStatusResponse.currentStatus = 'aeiou';
        signatureStatusResponse.horodatageCurrentStatus = Datetime.newInstanceGmt(2000, 1, 23, 4, 56, 7);
        signatureStatusResponse.signatairesStatus = new List<SwagSignatureSignataireStatus>{SwagSignatureSignataireStatus.getExample()};
        return signatureStatusResponse;
    }

    public Boolean equals(Object obj) {
        if (obj instanceof SwagSignatureStatusResponse) {
            SwagSignatureStatusResponse signatureStatusResponse = (SwagSignatureStatusResponse) obj;
            return this.customId == signatureStatusResponse.customId
                && this.currentStatus == signatureStatusResponse.currentStatus
                && this.horodatageCurrentStatus == signatureStatusResponse.horodatageCurrentStatus
                && this.signatairesStatus == signatureStatusResponse.signatairesStatus;
        }
        return false;
    }

    public Integer hashCode() {
        Integer hashCode = 43;
        hashCode = (17 * hashCode) + (customId == null ? 0 : System.hashCode(customId));
        hashCode = (17 * hashCode) + (currentStatus == null ? 0 : System.hashCode(currentStatus));
        hashCode = (17 * hashCode) + (horodatageCurrentStatus == null ? 0 : System.hashCode(horodatageCurrentStatus));
        hashCode = (17 * hashCode) + (signatairesStatus == null ? 0 : System.hashCode(signatairesStatus));
        return hashCode;
    }
}