package DefaultNamespace;

public class CCCCServiceProxy implements DefaultNamespace.CCCCService {
  private String _endpoint = null;
  private DefaultNamespace.CCCCService cCCCService = null;
  
  public CCCCServiceProxy() {
    _initCCCCServiceProxy();
  }
  
  public CCCCServiceProxy(String endpoint) {
    _endpoint = endpoint;
    _initCCCCServiceProxy();
  }
  
  private void _initCCCCServiceProxy() {
    try {
      cCCCService = (new DefaultNamespace.CCCCServiceServiceLocator()).getCCCCService();
      if (cCCCService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)cCCCService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)cCCCService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (cCCCService != null)
      ((javax.xml.rpc.Stub)cCCCService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public DefaultNamespace.CCCCService getCCCCService() {
    if (cCCCService == null)
      _initCCCCServiceProxy();
    return cCCCService;
  }
  
  public float divide(float x, float y) throws java.rmi.RemoteException{
    if (cCCCService == null)
      _initCCCCServiceProxy();
    return cCCCService.divide(x, y);
  }
  
  public float multiply(float x, float y) throws java.rmi.RemoteException{
    if (cCCCService == null)
      _initCCCCServiceProxy();
    return cCCCService.multiply(x, y);
  }
  
  public float minus(float x, float y) throws java.rmi.RemoteException{
    if (cCCCService == null)
      _initCCCCServiceProxy();
    return cCCCService.minus(x, y);
  }
  
  public float plus(float x, float y) throws java.rmi.RemoteException{
    if (cCCCService == null)
      _initCCCCServiceProxy();
    return cCCCService.plus(x, y);
  }
  
  
}