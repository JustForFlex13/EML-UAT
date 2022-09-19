/*
 * WSCursus Externe
 * Service externe du webservice WSCursus.
 *
 * The version of the OpenAPI document: 1
 * Contact: taubert@em-lyon.com
 *
 * NOTE: This class is auto generated by the OAS code generator program.
 * https://github.com/OpenAPITools/openapi-generator
 * Do not edit the class manually.
 */

/**
 * OASIdentityModel
 */
public class OASIdentityModel implements OAS.MappedProperties {
    /**
     * Get token
     * @return token
     */
    public String token { get; set; }

    /**
     * Get userName
     * @return userName
     */
    public String userName { get; set; }

    /**
     * Get displayName
     * @return displayName
     */
    public String displayName { get; set; }

    /**
     * Get email
     * @return email
     */
    public String email { get; set; }

    /**
     * Get claims
     * @return claims
     */
    public List<OASIdentityClaim> claims { get; set; }

    private static final Map<String, String> propertyMappings = new Map<String, String>{
        'Token' => 'token',
        'UserName' => 'userName',
        'DisplayName' => 'displayName',
        'Email' => 'email',
        'Claims' => 'claims'
    };

    public Map<String, String> getPropertyMappings() {
        return propertyMappings;
    }

    public OASIdentityModel() {
        claims = new List<OASIdentityClaim>();
    }

    public static OASIdentityModel getExample() {
        OASIdentityModel identityModel = new OASIdentityModel();
          identityModel.token = '';
          identityModel.userName = '';
          identityModel.displayName = '';
          identityModel.email = '';
          identityModel.claims = new List<OASIdentityClaim>{OASIdentityClaim.getExample()};
        return identityModel;
    }

    public Boolean equals(Object obj) {
        if (obj instanceof OASIdentityModel) {           
            OASIdentityModel identityModel = (OASIdentityModel) obj;
            return this.token == identityModel.token
                && this.userName == identityModel.userName
                && this.displayName == identityModel.displayName
                && this.email == identityModel.email
                && this.claims == identityModel.claims;
        }
        return false;
    }

    public Integer hashCode() {
        Integer hashCode = 43;
        hashCode = (17 * hashCode) + (token == null ? 0 : System.hashCode(token));
        hashCode = (17 * hashCode) + (userName == null ? 0 : System.hashCode(userName));
        hashCode = (17 * hashCode) + (displayName == null ? 0 : System.hashCode(displayName));
        hashCode = (17 * hashCode) + (email == null ? 0 : System.hashCode(email));
        hashCode = (17 * hashCode) + (claims == null ? 0 : System.hashCode(claims));
        return hashCode;
    }
}