using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DragCharacter : MonoBehaviour
{
    [SerializeField] private float rotationSpeed = 1f;

    private void OnMouseDrag()
    {
        float XaxisRotation = Input.GetAxis("Mouse X") * rotationSpeed;
        transform.Rotate(Vector3.down, XaxisRotation);
        
    }
}
