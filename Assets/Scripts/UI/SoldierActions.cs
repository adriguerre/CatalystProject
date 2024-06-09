using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoldierActions : MonoBehaviour
{

    [SerializeField] private Animator _animator;
    
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnEnable()
    {
        _animator.SetBool("Activated", true);
    }

    private void OnDisable()
    {
        _animator.SetBool("Activated", false);
    }
}
