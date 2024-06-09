using System;
using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using Unity.VisualScripting;
using UnityEngine;

public class Movement : MonoBehaviour
{

    [Header("Movement Properties")]
    [SerializeField] private float moveSpeed;
    [SerializeField] private float rotationSpeed = 15;
    [SerializeField] private float scrollSpeed = 15;
    
    [Header("Zoom Properties")]
    [SerializeField] private float _minFOV = 35;
    [SerializeField] private float _maxFOV = 76;
    [SerializeField] private float currentFOV = 76;
    [SerializeField] private float zoomChangeOnScroll = 5;
    
    [Header("Virtual Camera Reference")]
    [SerializeField] private CinemachineVirtualCamera virtualCamera;


    private Rigidbody _rigidbody;

    private void Start()
    {
        _rigidbody = GetComponent<Rigidbody>();
    }
    void Update()
    {

        
        //Checking Rotation
        if (Input.GetKey(KeyCode.Q))
            RotateCamera(true);
        else if (Input.GetKey(KeyCode.E))
            RotateCamera(false);
        
        //Check Zoom in Out
        float scroll = Input.GetAxis("Mouse ScrollWheel") * scrollSpeed;
        if (Input.mouseScrollDelta.y > 0)
            CheckCameraZoom(false);
        if (Input.mouseScrollDelta.y < 0)
            CheckCameraZoom(true);
    }

    private void FixedUpdate()
    {
        float horizontalMove = Input.GetAxis("Horizontal");
        float verticalMove = Input.GetAxis("Vertical");
        //Checking Movement
        CheckCameraMovement(verticalMove, horizontalMove);
        CheckMouseCameraMovement();
    }

    private void CheckCameraZoom(bool increaseZoom)
    {
        if (increaseZoom)
            currentFOV += zoomChangeOnScroll;
        else
            currentFOV -= zoomChangeOnScroll;
        
        currentFOV = Mathf.Clamp(currentFOV, _minFOV, _maxFOV);
        virtualCamera.m_Lens.FieldOfView = Mathf.Lerp(virtualCamera.m_Lens.FieldOfView, currentFOV, Time.deltaTime * scrollSpeed);
    }

    private void RotateCamera(bool left)
    {
        if (left)
        {
            transform.Rotate(Vector3.down * rotationSpeed * Time.deltaTime);
            virtualCamera.transform.Rotate(Vector3.forward * rotationSpeed * Time.deltaTime);
        }
        else
        {
            transform.Rotate(Vector3.up * rotationSpeed * Time.deltaTime);
            virtualCamera.transform.Rotate(-Vector3.forward * rotationSpeed * Time.deltaTime);
        }
    }

    private void CheckMouseCameraMovement()
    {
        float h;
        float v;
        int edgeScrollSize = 20;
        
        //TODO: Activar cuando sea necesario
        /*
        if(Input.mousePosition.x > Screen.width - edgeScrollSize)
            h = 1f;
        else if(Input.mousePosition.x < edgeScrollSize)
            h = -1f;
        else
            h = 0f;
        
        if (Input.mousePosition.y < edgeScrollSize)
            v = -1f;
        else if(Input.mousePosition.y > Screen.height - edgeScrollSize)
            v = 1f;
        else
            v = 0f;
        

        CheckCameraMovement(v, h);
        */
    }
    
    private void CheckCameraMovement(float v, float h)
    {
        Vector3 currentVelocity = _rigidbody.velocity;
        Vector3 targetVelocity = new Vector3(h, 0, v);
        targetVelocity *= moveSpeed;
        
        //Align Direction 
        targetVelocity = transform.TransformDirection(targetVelocity);

        Vector3 velocityChange = (targetVelocity - currentVelocity);

        Vector3.ClampMagnitude(velocityChange, 1);
        
        _rigidbody.AddForce(velocityChange, ForceMode.VelocityChange);

        //if (h != 0)
        //transform.Translate(Vector3.right * h * moveSpeed * Time.deltaTime);
        //if (v != 0)
        //transform.Translate(Vector3.forward * v * moveSpeed  * Time.deltaTime);
    }
}
