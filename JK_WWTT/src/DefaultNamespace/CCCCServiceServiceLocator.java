/**
 * CCCCServiceServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package DefaultNamespace;

public class CCCCServiceServiceLocator extends org.apache.axis.client.Service implements DefaultNamespace.CCCCServiceService {

    public CCCCServiceServiceLocator() {
    }


    public CCCCServiceServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public CCCCServiceServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for CCCCService
    private java.lang.String CCCCService_address = "http://localhost:8080/WJTest2/services/CCCCService";

    public java.lang.String getCCCCServiceAddress() {
        return CCCCService_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String CCCCServiceWSDDServiceName = "CCCCService";

    public java.lang.String getCCCCServiceWSDDServiceName() {
        return CCCCServiceWSDDServiceName;
    }

    public void setCCCCServiceWSDDServiceName(java.lang.String name) {
        CCCCServiceWSDDServiceName = name;
    }

    public DefaultNamespace.CCCCService getCCCCService() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(CCCCService_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getCCCCService(endpoint);
    }

    public DefaultNamespace.CCCCService getCCCCService(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            DefaultNamespace.CCCCServiceSoapBindingStub _stub = new DefaultNamespace.CCCCServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getCCCCServiceWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setCCCCServiceEndpointAddress(java.lang.String address) {
        CCCCService_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (DefaultNamespace.CCCCService.class.isAssignableFrom(serviceEndpointInterface)) {
                DefaultNamespace.CCCCServiceSoapBindingStub _stub = new DefaultNamespace.CCCCServiceSoapBindingStub(new java.net.URL(CCCCService_address), this);
                _stub.setPortName(getCCCCServiceWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("CCCCService".equals(inputPortName)) {
            return getCCCCService();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://DefaultNamespace", "CCCCServiceService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://DefaultNamespace", "CCCCService"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("CCCCService".equals(portName)) {
            setCCCCServiceEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
